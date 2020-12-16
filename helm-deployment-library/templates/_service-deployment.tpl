{{- define "depl.service" -}}
apiVersion: v1
kind: Service
metadata:
  name: {{ .Values.service.name | quote }}
  labels:
    app: {{ .Values.service.name | quote }}
spec:
  ports:
  - port: {{ .Values.service.port }}
    name: {{ .Values.service.portName }}
  selector:
    app: {{ .Values.service.name | quote }}
  sessionAffinity: None
  type: {{ default "ClusterIP" .Values.serviceType | quote }}
status:
  loadBalancer: {}
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Values.service.name | quote }}
  labels:
    app: {{ .Values.service.name | quote }}
spec:
  replicas: {{ default 1 .Values.replicasCount }}
  selector:
    matchLabels:
      app: {{ .Values.service.name | quote }}
  strategy:
    rollingUpdate:
      maxSurge: 0
      maxUnavailable: 1
    type: RollingUpdate
  template:
    metadata:
      labels:
        app: {{ .Values.service.name | quote }}
    spec:
      containers:
      - name: {{ .Values.service.name | quote }}
        image: {{ .Values.image.repository }}
        resources:
          limits:
            memory: "{{ .Values.limitsMemory }}"
          requests:
            memory: "{{ .Values.requestsMemory }}"
            cpu: {{ .Values.requestsCpu }}
        {{- if .Values.readinessProbe }}
        readinessProbe:
          httpGet:
            path: {{ default "/private/status" .Values.readinessProbe.path }}
            port: {{ default 8080 .Values.readinessProbe.port }}
          initialDelaySeconds: {{ default 20 .Values.readinessProbe.initialDelaySeconds }}
          timeoutSeconds: {{ default 1 .Values.readinessProbe.timeoutSeconds }}
        {{- end }}
        {{- if .Values.livenessProbe }}
        livenessProbe:
          httpGet:
            path: {{ default "/private/status" .Values.livenessProbe.path }}
            port: {{ default 8080 .Values.livenessProbe.port }}
          initialDelaySeconds: {{ default 20 .Values.livenessProbe.initialDelaySeconds }}
          timeoutSeconds: {{ default 1 .Values.livenessProbe.timeoutSeconds }}
        {{- end }}
        ports:
        - containerPort: {{ default 80 .Values.containerPort }}
          name: {{ default "http" .Values.portName }}
          protocol: {{ default "TCP" .Values.portProtocol }}
        {{- if .Values.env }}
        env:
{{ toYaml .Values.env | indent 10 }}
        {{- end }}
        {{- if .Values.configMapRef }}
        envFrom:
        - configMapRef:
            name: {{ .Values.configMapRef.deployEnv }}-config
            optional: true
        {{- end }}
      dnsPolicy: ClusterFirst
      restartPolicy: Always
      schedulerName: default-scheduler
      securityContext: {}
      terminationGracePeriodSeconds: 30
{{- end }}

{{- define "exec.job" -}}
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ .Values.job.name | quote }}
  labels:
    app.kubernetes.io/name: {{ .Values.job.name | quote }}
spec:
  completions: {{ .Values.completions | default 1 }}
  parallelism: {{ .Values.parallelism | default 1 }}
  backoffLimit: {{ .Values.backoffLimit | default 0 }}
  {{- if .Values.activeDeadlineSeconds }}
  activeDeadlineSeconds: {{ .Values.activeDeadlineSeconds }}
  {{- end }}
  {{- if .Values.ttlSecondsAfterFinished }}
  ttlSecondsAfterFinished: {{ .Values.ttlSecondsAfterFinished }}
  {{- end }}
  template:
    metadata:
      labels:
        app.kubernetes.io/name: {{ .Values.job.name | quote }}
    spec:
      restartPolicy: {{ .Values.restartPolicy | default "Never" }}
      containers:
        - image: {{ .Values.image.repository }}
          name: {{ .Values.job.name | quote }}
          imagePullPolicy: {{ .Values.imagePullPolicy | default "Always" }}
          {{- if .Values.env }}
          env:
{{ toYaml .Values.env | indent 12 }}
          {{- end }}
          resources:
            requests:
              memory: {{ .Values.requestsMemory }}
              cpu: {{ .Values.requestsCpu }}
            limits:
              memory: {{ .Values.limitsMemory }}
{{- end -}}

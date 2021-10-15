# helm-plugin
common chart for helm deployments

## Include repo
helm repo add --username bpstelios10 --password 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 helm-plugin 'https://raw.githubusercontent.com/bpstelios10/helm-plugin/master/'

## Adding new packages to existing repository
If you want to change the existing repository simply:
1) Do changes and change version in Chart.yaml
2) `helm package helm-deployment-library`
2) `helm repo index .` This will detect new file and update index.yaml.
3) Commit and push your new package and updated index.yaml

# cobrowse-test

## Pre-req
### Create fine-grane token in Github
Even when in the [docs](https://fluxcd.io/flux/installation/bootstrap/github/#github-personal-account) it says only needs Administration (read-only), after checking official documentation
for Github and testing it really needs:

 - Administration (rw)
 - Contents (rw)
 - Metadata (ro)

## Bootstrap instructions

### Login to GKE
```shell
gcloud container clusters get-credentials cobrowse-test-gke --zone us-central1-c
```
### Bootstrap flux
```shell
flux bootstrap github \
  --owner=$GITHUB_USER \
  --repository=cobrowse-test 
  --path=clusters/cobrowse-test
```

## Deployment instructions
### Create the podinfo source file
```shell
cobrowse-test % flux create source git podinfo \
  --url=https://github.com/stefanprodan/podinfo \
  --branch=master \
  --interval=1m \
  --export > ./clusters/cobrowse-test/podinfo-source.yaml
```
### Create kustomize config
```shell
flux create kustomization podinfo \
  --target-namespace=default \
  --source=podinfo \
  --path="./kustomize" \
  --prune=true \
  --wait=true \
  --interval=30m \
  --retry-interval=2m \
  --health-check-timeout=3m \
  --export > ./clusters/cobrowse-test/podinfo-kustomization.yaml
```

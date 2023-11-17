#!/bin/bash
APPNAME="hestekur"
REPO="https://github.com/entur/tmp-actions-with-argo.git"
DIR="helm/hest-er-best"
ENVS="dev prd"
# create project
argocd proj create $APPNAME -f - <<EOF
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: $APPNAME
spec:
    description: $APPNAME
    destinations:
    - namespace: $APPNAME
      server: https://kubernetes.default.svc
    orphanedResources:
      warn: true
    clusterResourceWhitelist:
    - group: '*'
      kind: '*'
    destinations:
    - namespace: '${APPNAME}-*'
      server: '*'
    sourceRepos:
    - '*'
EOF

for ENV in $ENVS; do
    argocd app create --project $APPNAME --name "AppFactory-${APPNAME}-${ENV}" --repo $REPO --path ".kustomize/overlays/${ENV}" \
        --dest-server https://kubernetes.default.svc --revision main --sync-policy none
    echo "Creating $APPNAME-$ENV"
    argocd app create --project $APPNAME --name "${APPNAME}-${ENV}" --repo $REPO --path "$DIR" \
        --values "env/values-${ENV}.yaml" \
        --dest-namespace "${APPNAME}-${ENV}" \
        -p service.type=LoadBalancer \
        -p release="${APPNAME}-${ENV}" \
        -p environment="$ENV" \
        -p common.container.image="eu.gcr.io/entur-system-1287/hest-er-best:pr-12" \
        --dest-server https://kubernetes.default.svc --revision main --sync-policy none --sync-option CreateNamespace=false
done



#argocd app create kustomize-guestbook --repo https://github.com/argoproj/argocd-example-apps.git --path kustomize-guestbook --dest-namespace default --dest-server https://kubernetes.default.svc --kustomize-image gcr.io/heptio-images/ks-guestbook-demo:0.1

#argocd app create --project default --name $APPNAME --repo $REPO --path $DIR --dest-server https://kubernetes.default.svc --dest-namespace $NAMESPACE --revision main --sync-policy none



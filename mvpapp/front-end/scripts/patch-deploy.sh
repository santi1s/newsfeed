#!/bin/bash
SCRIPT=`realpath $0`
SCRIPTPATH=`dirname $SCRIPT`

set -e

MANIFEST_DIR="${SCRIPTPATH}/../manifests"

cd ${MANIFEST_DIR}/test

# Patch SecretProviderClass
export KUBELET_IDENTITY=$(az aks show -n "aks-${APP}-${ENV}-${LOCATION}" -g "rg-${APP}-${ENV}-${LOCATION}" | jq -r '.identityProfile.kubeletidentity.clientId')
export KV_NAME=$(az keyvault list -g "rg-${APP}-${ENV}-${LOCATION}" --query '[].name' -o tsv)
envsubst < templates/test-spc.template.yaml > test-spc.yaml

#Patch Envs
export STATIC_URL=$(az storage account list -g rg-mvpapp-test-westeurope --query '[].primaryEndpoints.web' -o tsv)
envsubst < templates/test-env.template.yaml > test-env.yaml

#kustomize edit set image ${REMOTE_REGISTRY}/$1:${RELEASE_TAG}

kubectl --kubeconfig=$HOME/.kube/config.${APP}.${ENV}.${LOCATION} apply -k .



#!/bin/bash
SCRIPT=`realpath $0`
SCRIPTPATH=`dirname $SCRIPT`

set -e

MANIFEST_DIR="${SCRIPTPATH}/../manifests"

cd ${MANIFEST_DIR}/test
kustomize edit set image ${REMOTE_REGISTRY}/$1:${RELEASE_TAG}
kubectl --kubeconfig=$HOME/.kube/config.${APP}.${ENV}.${LOCATION} apply -k .


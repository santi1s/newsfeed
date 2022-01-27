#!/bin/bash
include(`macros.m4')
ARM_CLIENT_ID=__ARM_CLIENT_ID__
ARM_CLIENT_SECRET=__ARM_CLIENT_SECRET__
ARM_TENANT_ID=__ARM_TENANT_ID__
ENV=__ENV__
LOCATION=__LOCATION__
APP=__APP__

RG_NAME="rg-${APP}-${ENV}-${LOCATION}"
AKS_NAME="aks-${APP}-${ENV}-${LOCATION}"

set -e

. ./_library.sh

az login --service-principal -u ${ARM_CLIENT_ID} -p ${ARM_CLIENT_SECRET} --tenant ${ARM_TENANT_ID}

az aks get-credentials -n ${AKS_NAME} -g ${RG_NAME} --admin --file $HOME/.kube/config.${APP}.${ENV}.${LOCATION} --overwrite-existing

log_info "kubeconfig: $HOME/.kube/config.${APP}.${ENV}.${LOCATION}"
log_info "export KUBECONFIG=$HOME/.kube/config.${APP}.${ENV}.${LOCATION} to execute kubectl commands against the cluster"
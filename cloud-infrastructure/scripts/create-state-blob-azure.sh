#!/bin/bash
include(`macros.m4')
ARM_CLIENT_ID=__ARM_CLIENT_ID__
ARM_CLIENT_SECRET=__ARM_CLIENT_SECRET__
ARM_TENANT_ID=__ARM_TENANT_ID__
ENV=__ENV__
LOCATION=__LOCATION__
APP=__APP__
SA_NAME="satf${APP}${ENV}${LOCATION}"
RG_NAME="rg-terraform-${ENV}-${LOCATION}"
CONTAINER_NAME="terraform-${ENV}-${LOCATION}"

set -e

. ./_library.sh

az login --service-principal -u ${ARM_CLIENT_ID} -p ${ARM_CLIENT_SECRET} --tenant ${ARM_TENANT_ID}

rg_exists=$(az group exists --name ${RG_NAME})

if [ $rg_exists == "false" ];then
    az group create --location ${LOCATION} --name ${RG_NAME}
    log_normal "Resource group ${RG_NAME} created"
else
    log_warn "Resource group ${RG_NAME} for terraform state already exists. Skipping creation"
fi


SA_EXISTS=$(az storage account list --resource-group ${RG_NAME} --query "[?name=='${SA_NAME}']" -o tsv | wc -l)
if [ $SA_EXISTS -eq 1 ]; then
     log_fail "Storage account ${SA_NAME} for terraform state already exists. Skipping creation and exiting"
else
    az storage account create --name  ${SA_NAME} --resource-group ${RG_NAME}
    az storage container create -n ${CONTAINER_NAME} --account-name ${SA_NAME} --public-access off --fail-on-exist
    log_normal "Storage account container ${CONTAINER_NAME} in ${SA_NAME} created"
fi
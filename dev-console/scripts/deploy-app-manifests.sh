#!/bin/bash
SCRIPT=`realpath $0`
SCRIPTPATH=`dirname $SCRIPT`

. "${SCRIPTPATH}/_library.sh"

set -e

APP_DIR="${SCRIPTPATH}/../../mvpapp"

log_info "Deploying services to AKS"
make -C "${APP_DIR}" deploy && log_pass "Deployment successfull" || ( log_fail "Deployment failed" ; exit 1 )

SVC_IP=$(kubectl get service front-end -n mvpapp -ojson | jq -r '.status.loadBalancer.ingress[0].ip')
log_separator
log_info "\nNewsfeed Server Up and ready in http://${SVC_IP}:8080"
log_separator
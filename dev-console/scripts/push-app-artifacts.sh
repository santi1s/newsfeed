#!/bin/bash


SCRIPT=`realpath $0`
SCRIPTPATH=`dirname $SCRIPT`

. "${SCRIPTPATH}/_library.sh"

set -e

APP_DIR="${SCRIPTPATH}/../../mvpapp"

log_info "Tag Docker Images"
make -C "${APP_DIR}" tag && log_pass "App Images successfully tagged" || ( log_fail "Tag failed" ; exit 1 )

log_info "Pushing container images to Azure Container Registry"
make -C "${APP_DIR}" login > /dev/null && log_pass "Login successfull" || ( log_fail "Login failed" ; exit 1 )
make -C "${APP_DIR}" push  && log_pass "Push successfull" || ( log_fail "Push failed" ; exit 1 )

log_info "Pushing static content to Azure Storage Account with static website"
tar -zxvf ${APP_DIR}/build/static.tgz -C /tmp
az storage blob upload-batch -s /tmp/css -d '$web' --account-name stormvpatestwest001



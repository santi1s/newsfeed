#!/bin/bash

SCRIPT=`realpath $0`
SCRIPTPATH=`dirname $SCRIPT`

. "${SCRIPTPATH}/_library.sh"

set -e

INFRA_DIR="${SCRIPTPATH}/../../cloud-infrastructure"

log_info "Running Terraform destroy"
make -C "${INFRA_DIR}" destroy && log_pass "Terraform destroy successfull" || ( log_fail "Terraform destroy with errors" ; exit 1 )

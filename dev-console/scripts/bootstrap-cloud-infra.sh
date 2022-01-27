#!/bin/bash

SCRIPT=`realpath $0`
SCRIPTPATH=`dirname $SCRIPT`

. "${SCRIPTPATH}/_library.sh"

set -e

INFRA_DIR="${SCRIPTPATH}/../../cloud-infrastructure"

log_info "Creating Azure storage blob for storing the shared terraform state"
make -C "${INFRA_DIR}" state && log_pass "Created successfully" || ( log_fail "Could not create state blob" ; exit 1 )

log_info "Running  Terraform plan"
make -C "${INFRA_DIR}" plan && log_pass "Terraform plan OK" || ( log_fail "Terraform plan with errors" ; exit 1 )

log_info "Running Terraform apply"
make -C "${INFRA_DIR}" apply && log_pass "Terraform plan applied successfully" || ( log_fail "Terraform plan with errors" ; exit 1 )

log_info "Generate kube config file"
make -C "${INFRA_DIR}" kube-config && log_pass "kubeconfig generated" || ( log_fail "failed to generate kubeconfig" ; exit 1 )

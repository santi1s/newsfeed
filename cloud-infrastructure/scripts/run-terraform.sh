#!/bin/bash
include(`macros.m4')
ARM_CLIENT_ID=__ARM_CLIENT_ID__
ARM_CLIENT_SECRET=__ARM_CLIENT_SECRET__
ARM_TENANT_ID=__ARM_TENANT_ID__
ARM_SUBSCRIPTION_ID=__ARM_SUBSCRIPTION_ID__
ENV=__ENV__
LOCATION=__LOCATION__
APP=__APP__
SA_NAME="satf${APP}${ENV}${LOCATION}"
RG_NAME="rg-terraform-${ENV}-${LOCATION}"
CONTAINER_NAME="terraform-${ENV}-${LOCATION}"


# Exit when any command returns a failure status.
set -e

SCRIPT=$(realpath $0)
SCRIPTPATH=$(dirname $SCRIPT)


usage()
{
cat << EOF  
Usage: $0 -c <command> -e <environment> -l <location>
Run Terraform
-h,--help   Print usage
-c,         [Required] Terraform command to run - plan, apply, destroy
-e,         [Required] Environment - dev,test,qa,prd
-l,         [Required] Location - azure location
EOF
} 


options=$(getopt -l "help" -o "ihc:e:l:s:" -a -- "$@")
eval set -- "$options"
#get options
while true; do
    case $1 in
        -i)
            unset CMD;unset ENV;unset LOC
            ;;
        -h|--help)
            usage; exit 0
            ;;
        -c)
            shift
            CMD=$1
            ;;
        -e)
            shift
            ENV=$1
            ;;
        -l)
            shift
            LOCATION=$1
            ;;
        --)
            shift
            break
            ;;
    esac
    shift
done

if ( [ -z "${CMD}" ] || [ -z "${ENV}" ] || [ -z "${LOCATION}" ] ); then usage; exit 1 ;fi

cd ${SCRIPTPATH}/../terraform

envsubst < main.tfvars.template > main.tfvars

# Initialize Terraform.
terraform init -upgrade -backend-config="storage_account_name=${SA_NAME}" \
-backend-config="container_name=${CONTAINER_NAME}" \
-backend-config="key=infra.tfstate" \
-backend-config="resource_group_name=${RG_NAME}" \
-backend-config="subscription_id=${ARM_SUBSCRIPTION_ID}" \
-backend-config="tenant_id=${ARM_TENANT_ID}" \
-backend-config="client_id=${ARM_CLIENT_ID}" \
-backend-config="client_secret=${ARM_CLIENT_SECRET}"

case "${CMD}" in
        plan)
            terraform plan -var-file="main.tfvars"  -out="${SCRIPTPATH}/../${ENV}.${LOCATION}.tfplan"
            ;;
        apply)
            terraform apply -input=false -auto-approve "${SCRIPTPATH}/../${ENV}.${LOCATION}.tfplan"
            ;;
        destroy)
            terraform destroy -input=false -auto-approve
            ;;
        output)
            terraform output -json
            ;;
        --)
            usage; exit 1
            ;;
esac



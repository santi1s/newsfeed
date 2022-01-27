#!/bin/bash
SCRIPT=`realpath $0`
SCRIPTPATH=`dirname $SCRIPT`

. "${SCRIPTPATH}/_library.sh"

set -e

APP_DIR="${SCRIPTPATH}/../../mvpapp"

log_info "Building common jars and installing in ~/m2"
make -C "${APP_DIR}" libs && log_pass "Build successfull" || ( log_fail "Build failed" ; exit 1 )

log_info "Building app jars and static content"
make -C "${APP_DIR}" clean all  && log_pass "Build successfull" || ( log_fail "Build failed" ; exit 1 )

log_info "Running apps unit tests"
make -C "${APP_DIR}" test && log_pass "Tests successfull" || ( log_fail "Tests failed" ; exit 1 )

log_info "Building apps docker container"
make -C "${APP_DIR}" LOCAL_TAG=$LOCAL_TAG container  && log_pass "Docker build successfull" || ( log_fail "build failed" ; exit 1 )

#!/bin/bash
BOLD='\033[1m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m'

function yes_no() {
  PROMPT="$1"
  read -p "$1 (y/n) " RESP

  while [[ "$RESP" != "y" ]] && [[ "$RESP" != "n" ]]; do
    echo "Wrong input!"
    read -p "$1 (y/n)" RESP
  done

  echo "${RESP}"
}

function log_normal() {
  line="[$(date)] ${1}"
  echo -e "$line"
  if [[ -n "${LOG_FILE:-}" ]]; then
    echo "$line" >>"${LOG_FILE}"
  fi
}

function log_separator() {
  log_normal "--------------------------------------------------"
}

function log_test() {
  log_separator
  log_normal "${CYAN}[TEST]${NC} ${BOLD}${1}${NC}"
  log_separator
}

function log_info() {
  log_normal "${WHITE}[INFO]${NC} ${BOLD}${1}${NC}"
}

function log_error() {
  log_normal "${YELLOW}[ERROR]${NC} ${BOLD}${1}${NC}"
}

function log_warn() {
  log_normal "${YELLOW}[WARN]${NC} ${BOLD}${1}${NC}"
}

function log_pass() {
  log_normal "${GREEN}[PASS]${NC} ${BOLD}${1}${NC}"
}

function log_fail() {
  log_normal "${RED}[FAIL]${NC} ${BOLD}${1}${NC}"
}

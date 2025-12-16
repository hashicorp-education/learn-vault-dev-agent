#!/bin/bash
# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0
set -e

yell() { echo ": $*" >&2; }
die() { yell "$*"; exit 111; }
try() { "$@" || die "cannot $*"; }

try minikube status

terraform -chdir=terraform/vault-server/ init && terraform -chdir=terraform/vault-server/ apply -auto-approve
sleep 3

terraform -chdir=terraform/kubernetes/ init && terraform -chdir=terraform/kubernetes/ apply -auto-approve
sleep 3

# rolled vault commands into the kubectl directory config to ensure proper timing

terraform -chdir=terraform/app init && terraform -chdir=terraform/app apply -auto-approve



## functions
function()
{
   echo "a function"
}

# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

data "external" "get-k8s-host" {
  program = ["bash", "${path.module}/script.sh"]
}

variable "external_vault_addr" {
 description = "External Vault address for Vault Agent to connect to"
  type        = string
  default     = ""
}

locals {
   external_vault_addr = var.external_vault_addr != "" ? var.external_vault_addr : "http://${data.external.get-k8s-host.result["EXTERNAL_VAULT_ADDR"]}:8200"
} 

variable "kube_service_name" {
  description = "service name used by agent to access vault"
  default     = "vault-auth"
}
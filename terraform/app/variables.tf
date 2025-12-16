# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "kube_service_name" {
  description = "service name used by agent to access vault"
  default     = "vault-auth"
}

# variable "external_vault_addr" {
#   description = "External Vault address for Vault Agent to connect to"
#   type        = string
# }
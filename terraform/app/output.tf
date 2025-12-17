# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "external_vault_addr" {
   description = "External Vault address for Vault Agent to connect to"
   value       = "http://${data.external.get-k8s-host.result["EXTERNAL_VAULT_ADDR"]}:8200"
} 
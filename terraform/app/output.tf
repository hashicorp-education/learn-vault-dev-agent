output "external_vault_addr" {
   description = "External Vault address for Vault Agent to connect to"
   value       = "http://${data.external.get-k8s-host.result["EXTERNAL_VAULT_ADDR"]}:8200"
} 


output "raw" {
   description = "External Vault address for Vault Agent to connect to"
   value       = data.external.get-k8s-host.result
} 
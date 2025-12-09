# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# replaces devwebapp.yaml
resource "kubernetes_pod_v1" "devwebapp" {
  metadata {
    name = "devwebapp"
    labels = {
      app = "devwebapp"
    }
  }
  spec {
    service_account_name = kubernetes_service_account.vault-auth.metadata[0].name
    container {
      image = "burtlo/devwebapp-ruby:k8s"
      name  = "devwebapp-pod"
      env {
        name  = "VAULT_ADDR"
        value = "http://${var.external_vault_addr}:8200"
      }
    }
  }
}
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
    service_account_name = var.kube_service_name
    container {
      image = "burtlo/devwebapp-ruby:k8s"
      name  = "devwebapp-pod"
      env {
        name  = "VAULT_ADDR"
        value = "http://${data.external.get-k8s-host.result["EXTERNAL_VAULT_ADDR"]}:8200"
      }
    }
  }
}
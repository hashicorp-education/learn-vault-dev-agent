# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# replaces vault-auth-secret.yaml
resource "kubernetes_secret_v1" "vault-auth-secret" {
  metadata {
    name = "vault-auth-secret"
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account.vault-auth.metadata[0].name
    }
  }
  type = "kubernetes.io/service-account-token"
}
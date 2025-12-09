# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# replaces vault-auth-service-account.yaml
resource "kubernetes_service_account" "vault-auth" {
  metadata {
    name = "vault-auth"
  }
}

resource "kubernetes_cluster_role_binding" "role-tokenreview-binding" {
  metadata {
    name = "role-tokenreview-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "system:auth-delegator"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "vault-auth"
    namespace = "default"
  }
}
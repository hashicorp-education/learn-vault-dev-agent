# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

// replaces configmap.yaml
resource "kubernetes_config_map_v1" "agent-config" {
  metadata {
    name      = "example-vault-agent-config"
    namespace = "default"
  }
  data = {
    "vault-agent-config.hcl" = "${file("vault-agent-config.hcl")}"
  }
}

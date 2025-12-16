# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

data "external" "get-k8s-host" {
  program = ["bash", "${path.module}/script.sh"]
}

# replaces vault-agent-example.yaml
resource "kubernetes_pod_v1" "vault-agent" {
  metadata {
    name      = "vault-agent-example"
    namespace = "default"
    #  labels = {
    #    app = "vault-agent"
    #  }
  }
  spec {
    service_account_name = var.kube_service_name
    volume {
      name = "config"
      config_map {
        name = "example-vault-agent-config"
        items {
          key  = "vault-agent-config.hcl"
          path = "vault-agent-config.hcl"
        }
      }
    }
    volume {
      name = "shared-data"
      empty_dir {}
    }

    init_container {
      name  = "vault-agent"
      image = "hashicorp/vault"
      args = [
        "agent",
        "-config=/etc/vault/vault-agent-config.hcl",
        "-log-level=debug"
      ]
      env {
        name = "VAULT_ADDR"
        #   value = "http://192.168.65.254:8200"
        value = "http://${data.external.get-k8s-host.result["EXTERNAL_VAULT_ADDR"]}:8200"
      }
      volume_mount {
        name       = "config"
        mount_path = "/etc/vault"
      }
      volume_mount {
        name       = "shared-data"
        mount_path = "/etc/secrets"
      }
    }
    container {
      name  = "nginx-container"
      image = "nginx"
      port {
        container_port = 80
      }
      volume_mount {
        mount_path = "/usr/share/nginx/html"
        name       = "shared-data"
      }
    }
  }

}
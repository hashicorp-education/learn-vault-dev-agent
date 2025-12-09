# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Get the latest Vault image
resource "docker_image" "vault" {
  name = "hashicorp/${var.VAULT_EDITION}:latest"
}

# Start a Vault container in dev mode
resource "docker_container" "vault" {
  name  = "learn-vault"
  image = docker_image.vault.image_id
#   env = ["VAULT_DEV_ROOT_TOKEN_ID=root", "VAULT_DEV_LISTEN_ADDRESS=0.0.0.0:8200", "VAULT_LICENSE=${var.VAULT_LICENSE}"]
   env = ["VAULT_DEV_ROOT_TOKEN_ID=root", "VAULT_LICENSE=${var.VAULT_LICENSE}"]
   network_mode = "host"
  ports {
    internal = 8200
    external = 8200
    }
  rm = true
}
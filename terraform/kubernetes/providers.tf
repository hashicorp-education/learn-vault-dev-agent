# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
#     docker = {
#       source  = "kreuzwerker/docker"
#       version = "3.6.2"
#     }
#   }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
    config_context = "minikube"
}

# provider "docker" {
#   # Configuration options
# }
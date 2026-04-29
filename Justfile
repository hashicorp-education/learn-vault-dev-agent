# Copyright IBM Corp. 2018, 2026
# SPDX-License-Identifier: MPL-2.0

set dotenv-load

# List all available commands
default:
    @just --list

# Run all steps
alias all := run-all

# Run the entire tutorial workflow
run-all: version lab-setup minikube-start minikube-status kubernetes-vault-resources web-app-vault-agent verification clean-up

# Print versions of all tools used in the tutorial
version:
    @echo "=== Tool Versions ==="
    @vault version
    @kubectl version --client
    @docker --version
    @minikube version
    @jq --version
    @git --version
    @terraform version

# Export environment variables for Vault CLI
env-vars:
    # to export env variables: eval $(just env-vars | xargs)'
    @echo "export VAULT_ADDR=$VAULT_ADDR VAULT_TOKEN=$VAULT_TOKEN"

# Start Vault dev server and set environment variables
lab-setup:
    @echo "=== Starting Vault dev server ==="
    @echo "Note: Vault server will run in the background"
    vault server -dev -dev-root-token-id root > vault-server.log 2>&1 &
    @sleep 3
    @echo "Vault server started. Logs: vault-server.log"
    @echo ""
    @echo "Environment variables (add to your shell):"
    @echo "  export VAULT_ADDR=http://127.0.0.1:8200"
    @echo "  export VAULT_TOKEN=root"

# Clone the learn-vault-dev-agent repository
clone-repo:
    @echo "=== Cloning repository ==="
    git clone https://github.com/hashicorp-education/learn-vault-dev-agent.git || true

# Start minikube cluster
minikube-start:
    @echo "=== Starting minikube cluster ==="
    minikube start

# Verify minikube cluster status
minikube-status:
    @echo "=== Verifying minikube cluster status ==="
    minikube status

# Create Kubernetes and Vault resources using Terraform
kubernetes-vault-resources:
    @echo "=== Creating Kubernetes and Vault resources ==="
    terraform -chdir=terraform/kubernetes/ init
    terraform -chdir=terraform/kubernetes/ apply -auto-approve
    @echo ""
    @echo "=== Verifying service account creation ==="
    kubectl get serviceaccount vault-auth
    @echo ""
    @echo "=== Verifying secret creation ==="
    kubectl get secret vault-auth-secret
    @echo ""
    @echo "=== Verifying Vault auth methods ==="
    vault auth list
    @echo ""
    @echo "=== Verifying Vault role ==="
    vault read auth/kubernetes/role/vault-kube-auth-role
    @echo ""
    @echo "=== Verifying Vault policies ==="
    vault policy list
    @echo ""
    @echo "=== Verifying API key secret ==="
    vault kv get secret/myapp/api-key

# Examine Vault Agent ConfigMap
examine-config:
    @echo "=== Examining Vault Agent ConfigMap ==="
    cat terraform/app/vault-agent-config.hcl

# Deploy web application and Vault Agent
web-app-vault-agent: examine-config
    @echo "=== Deploying web application and Vault Agent ==="
    terraform -chdir=terraform/app init
    terraform -chdir=terraform/app apply -auto-approve
    @echo ""
    @echo "=== Displaying running pods ==="
    kubectl get pods
    @echo ""
    @echo "=== Displaying containers in vault-agent-example pod ==="
    kubectl get pod vault-agent-example -o jsonpath='{.spec.containers[*].name}{"\n"}{.spec.initContainers[].name}'

# Verification instructions
verification:
    @echo "=== Verification Instructions ==="
    @echo ""
    @echo "1. In another terminal, port forward requests to the vault-agent-example pod:"
    @echo "   kubectl port-forward pod/vault-agent-example 8080:80"
    @echo ""
    @echo "2. In a web browser, navigate to: http://localhost:8080"
    @echo ""
    @echo "3. You should see a page displaying the username and password values"
    @echo "   from secret/myapp/api-key"
    @echo ""
    @echo "Expected output:"
    @echo "  Some secrets:"
    @echo "  - username: <value>"
    @echo "  - password: <value>"

# Clean up all resources
clean-up:
    @echo "=== Cleaning up resources ==="
    @echo "Note: Stop kubectl port-forward manually if running"
    -terraform -chdir=terraform/app apply -destroy -auto-approve
    -terraform -chdir=terraform/kubernetes/ apply -destroy -auto-approve
    -minikube stop
    -minikube delete --all --purge
    -pkill vault
    @echo ""
    @echo "=== Cleanup complete ==="

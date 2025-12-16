
# Manifests

``
kaf manifests/vault-auth-service-account.yaml
kaf manifests/vault-auth-secret.yaml

# vault commands here

kaf manifests/devwebapp.yaml
kaf manifests/configmap.yaml
kaf manifests/vault-agent.yaml
``

# Terraform config

``
minikube start

export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN=root

terraform -chdir=terraform/vault-server/ init && terraform -chdir=terraform/vault-server/ apply -auto-approve

terraform -chdir=terraform/kubernetes/ init && terraform -chdir=terraform/kubernetes/ apply -auto-approve

eval "$(terraform -chdir=terraform/kubernetes/ output -json ENVIRONMENT_VARIABLES | jq -r ".")"

terraform apply -auto-approve -target=resource.kubernetes_pod_v1.devwebapp -target=resource.kubernetes_config_map_v1.agent-config -target=resource.kubernetes_pod_v1.vault-agent -auto-approve
```

# vault set up

```
vault policy write myapp-api-key-policy - <<EOF
path "secret/data/myapp/*" {
  capabilities = ["read", "list"]
}
EOF

vault kv put secret/myapp/api-key \
  access_key='appuser' \
  secret_access_key='suP3rsec(et!'

export SA_SECRET_NAME=$(kubectl get secrets --output=json | jq -r '.items[].metadata | select(.name|startswith("vault-auth-")).name')

export SA_JWT_TOKEN=$(kubectl get secret $SA_SECRET_NAME --output 'go-template={{ .data.token }}' | base64 --decode)

export SA_CA_CRT=$(kubectl config view --raw --minify --flatten --output 'jsonpath={.clusters[].cluster.certificate-authority-data}' | base64 --decode)

export K8S_HOST=$(kubectl config view --raw --minify --flatten --output 'jsonpath={.clusters[].cluster.server}')

vault auth enable kubernetes

vault write auth/kubernetes/config \
     token_reviewer_jwt="$SA_JWT_TOKEN" \
     kubernetes_host="$K8S_HOST" \
     kubernetes_ca_cert="$SA_CA_CRT" \
     issuer="https://kubernetes.default.svc.cluster.local"

vault write auth/kubernetes/role/vault-kube-auth-role \
     bound_service_account_names=vault-auth \
     bound_service_account_namespaces=default \
     token_policies=myapp-api-key-policy \
     audience=https://kubernetes.default.svc.cluster.local \
     ttl=24h

vault read auth/kubernetes/role/vault-kube-auth-role
vault read auth/kubernetes/config

export TF_VAR_external_vault_addr=$(minikube ssh "dig +short host.docker.internal" | tr -d '\r')
```

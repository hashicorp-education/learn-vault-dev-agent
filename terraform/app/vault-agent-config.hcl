# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Comment this out if running as sidecar instead of initContainer
exit_after_auth = true

pid_file = "/home/vault/pidfile"

auto_auth {
   method "kubernetes" {
      mount_path = "auth/kubernetes"
      config = {
            role = "vault-kube-auth-role"
      }
   }

   sink "file" {
      config = {
            path = "/home/vault/.vault-token"
      }
   }
}

template {
destination = "/etc/secrets/index.html"
contents = <<EOT
<html>
<body>
<p>Some secrets:</p>
{{- with secret "secret/data/myapp/api-key/" }}
<ul>
<li><pre>username: {{ .Data.data.access_key }}</pre></li>
<li><pre>password: {{ .Data.data.secret_access_key }}</pre></li>
</ul>
{{ end }}
</body>
</html>
EOT
}
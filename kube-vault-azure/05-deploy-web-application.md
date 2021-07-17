# Deploy web application

> The web application pod requires the creation of tje `internal-app` Kubernetes service account specified in the Vault Kubernetes authentication role created in the [Configure Kubernetes authentication](./03-configure-kube-auth.md) step.
> Define a Kubernetes service account named `internal-app`.

```bash
cat > internal-app.yaml <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: internal-app
EOF
```

> Create the `internal-app` service account.
```bash
kuectl apply --filename internal-app.yaml
``` 

> Define a pod named devwebapp with the web application.

```bash
cat > devwebapp.yaml <<EOF
---
apiVersion: v1
kind: Pod
metadata:
  name: devwebapp
  labels:
    app: devwebapp
  annotations:
    vault.hashicorp.com/agent-inject: "true"
    vault.hashicorp.com/role: "devweb-app"
    vault.hashicorp.com/agent-inject-secret-credentials.txt: "secret/data/devwebapp/config"
spec:
  serviceAccountName: internal-app
  containers:
    - name: devwebapp
      image: jweissig/app:0.0.1
EOF
```

> This definition creates a pod with the specified container running with the `internal-app` Kubernetes service account. The container within the pod is unware of the Vault cluster. The Vault injector service reads the [annotations](https://www.vaultproject.io/docs/platform/k8s/injector/index.html#annotations) to find the secret path, stored within Vault at `secret/data/devwebapp/config` and the file location, `/vault/secrets/secret-credentials.txt`, to mount that secret with the pod.

> Create the `devwebapp` pod.
```bash
kubectl apply --filename devwebapp.yaml
```

> Get all pods within the default namespace.
```bash
kubectl get pods
```
  - Wait until the `devwebapp` pod reports that is running and ready (`2/2`).
> Display the secrets written to the file `/vault/secrets/secret-credentials.txt` on the `devwebapp` pod.
```bash
kubectl exec --stdin=true --tty=true devwebapp --container=devwebapp \
-- cat /vault/secrets/credentials.txt
```
  - The result displays the unformatted secret data present on the container.
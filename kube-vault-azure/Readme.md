# Vault Installation to Azure Kubernetes Service via Helm

## Prerequisites
- This tutorial requires a [Azure account](https://azure.microsoft.com/en-us/account/), [Azure command-line interface (CLI)](https://docs.microsoft.com/en-us/cli/azure/), [Kubernetes CLI](https://kubernetes.io/docs/tasks/tools/install-kubectl/) and the [Helm CLI](https://helm.sh/docs/helm/).

- First, create a [Azure account](https://azure.microsoft.com/en-us/account/).

- Next, install [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/), [kubectl CLI](https://kubernetes.io/docs/tasks/tools/install-kubectl/) and [helm CLI](https://github.com/helm/helm#install).

## Login to azure via command terminal. 
- ```
    az login
  ```
- This command launches the browser and requires that you authenticate with your microsoft account credentials.
- The kubernetes cluster that you run needs to be created in a Azure resource group.
- A resource group is a container that holds related resources for an azure solution.
- The resource group is created with a name and a [location](https://azure.microsoft.com/en-us/global-infrastructure/geographies/).

- Display all the locations available to your account.
  ```
    az account  list list-locations | jq -r ".[].name"
  ```

- Create a resource group name `learn-vault-with-kube-azure` with the location selected
  ```
    az group create --name learn-vault-with-kube-azure --location southeastasia
  ``` 
  - The `learn-vault-with-kube-azure` resource group will be created in the `southeastasia` location.

## Start Cluster
- Kubernetes clusters may run one or more nodes. Each node contains the services to run pods. 
- Vault running in standalone mode requires one node.
- Create a cluster named `learn-vault-with-kube-azure-cluster` with `1` node in `learn-vault-with-kube-azure` resource group.
```
az aks create --resource-group learn-vault-with-kube-azure \
    --name learn-vault-with-kube-azure-cluster \
    --node-count 1 \
    --enable-addons monitoring \
    --generate-ssh-keys
```
- The cluster will be created.

- When the cluster is read, the `kubectl` CLI requires configuration to communicate with this cluster.
- Configure the kubectl CLI to communicate to the `learn-vault-with-kube-azure-cluster` cluster.
```
az aks get-credentials --resource-group learn-vault-with-kube-azure --name learn-vault-with-kube-azure-cluster
```

## Install the Vault Helm chart
- The recommended way to run Vault on Kubernetes is via the [Helm Chart](https://www.vaultproject.io/docs/platform/k8s/helm.html).

- Add the HashiCorp Helm repository.
```
helm repo add hashicorp https://helm.releases.hashicorp.com
```

- Update all the repositories to ensure `helm` is aware of the latest versions.
```
helm repo update
```

- Search for all the Vault Helm chart versions.
```
helm search repo vault --version
```
- The Vault Helm chart contains all the necessary components to run Vault in several different modes.
> **Default behaviour:** By default, it launches Vault in standalone mode with a file storage backend on a single pod. Enabling the Vault web UI requires that you override the defaults.

- Install the latest version of the Vault Helm chart with the Web UI enabled.
```
helm install vault hashicorp/vault \
--set='ui.enabled=true'   \
--set='ui.serviceType=LoadBalancer'
```
- The Vault pod, Vault Agent Injector pod, and Vault UI Kubernetes service are deployed in the default namespace.

- Get all the pods within the default namespace.
```
kubectl get pods
```
- The `vault-0` pod deployed runs a Vault server and repors that it is `Running` but that is not ready (`0/1`). This is because the status check defined in a [readinessProbe](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-probes) return a non-zero exit code.
- The `vault-agent-injector` pods deployed is a Kubernetes Mutation Webhook Controller. The controller intercepts pod events and applies mutations to the pod if specific annotations exist within the request.
- Retrieve the status of Vault on the `vault-0` pod.
```
kubectl exec vault-0 -- vault status
```

## Initialize and unseal Vault
- Vault starts [uninitialized](https://www.vaultproject.io/docs/commands/operator/init.html) and in the [sealed](https://www.vaultproject.io/docs/concepts/seal/#why) state. The process of initializing and unsealing Vault can e performed via the exposed Web UI.
- The Vault web UI is available through a Kubernetes service.
- Display the `vault-ui` service in the default namespace.
```
kubectl get service vault-ui
```
- The `EXTERNAL-IP` displays the IP address of the Vault UI.
  1. Launch a web browser, and enter the *EXTERNAL-IP* with the port `8200` in the address.
  2. Enter `5` in the **Key shares** and `3` in the **Key threshold** text fields.
  3. Click **Initialize**.
  4. When the root token and unseal key is presented, scroll down to the buttom and select **Download keys**. Save the generated unseal keys file to your computer.
    - The unseal process requires these keys and the access requires the root token.
  5. Click **Continue to Unseal** to proceed.
  6. Open the download file.
  7. Copy one of the `keys` (not `key_base64`) and enter it in the **Master Key Portion** field. Click **Unseal** to proceed.
    - The Unseal status show `1/3 keys provided`.
  8. Enter anothe key and click **Unseal**.
    - The Unseal status show `2/3 keys provided`.
  9. Enter another key and click **Unseal**.
    - After 3 out of 5 unseal keys are entered, Vault is unsealed and is ready to operate.
  10. Copy the `root_token` and enter its value in the **Token** field. Click **Sign In**.      
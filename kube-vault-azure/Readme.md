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

- When the cluster is ready.the `kubectl` CLI requires configuration to communicate with this cluster.
- Configure the kubectl CLI to communicate to the `learn-vault-with-kube-azure-cluster` cluster.
```
az aks get-credentials --resource-group learn-vault-with-kube-azure --name learn-vault-with-kube-azure-cluster
```
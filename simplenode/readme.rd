* Deploy very simple node app into Azure Kubernetes Service

1) Run PowerShell as Admin
az login

2) Create a resource group
az group create --name kubesampRG --location westeurope

3) Cree an Azure Container Registry
az acr create --resource-group kubesampRG --name kubesampconACR --sku Basic

4) Login into Azure Container Registry
az acr login --name kubesampconACR

5) Get address of server
az acr list --resource-group kubesampRG --query "[].{acrLoginServer:loginServer}" --output table

6) Make sure do you have an docker image (on my docker hub, ctello/composesample image)

7) Tag the image
docker tag ctello/composesample kubesampconacr.azurecr.io/composesample:v1

8) Push to ACR
docker push kubesampconacr.azurecr.io/composesample:v1

9) List the images in the ACR
az acr repository list --name kubesampconACR --output table

10) To manage Kubernetes in azure we need to create an Entity Service first.
az ad sp create-for-rbac --skip-assignment

{
  "appId": "XXXXXXX-3c5d-43b7-ace4-29be342bb171",
  "displayName": "azure-cli-2019-03-04-16-33-28",
  "name": "http://azure-cli-2019-03-04-16-33-28",
  "password": "YYYYYY-66ae-4713-9769-4b754a482539",
  "tenant": "0e30c02b-2f31-4c3e-875a-780c3467caca"
}

Please, write out, "appId" and "password" values.

11) Get ACR id to add it into previous Entity Service
az acr show --resource-group kubesampRG --name kubesampconACR --query "id" --output tsv

Also, write out the "id" value.

12) Allow access
az role assignment create --assignee <Entity Service AppId> --scope <ACR id> --role acrpull

eg:
az role assignment create --assignee XXXXXXX-3c5d-43b7-ace4-29be342bb171 --scope /subscriptions/5f4d7b4b-0b36-429b-acb5-b14b444a9fd0/resourceGroups/kubesampRG/providers/Microsoft.ContainerRegistry/registries/kubesampconACR --role acrpull

Output:

{
  "canDelegate": null,
  "id": "/subscriptions/5f4d7b4b-0b36-429b-acb5-b14b444a9fd0/resourceGroups/kubesampRG/providers/Microsoft.ContainerRegistry/registries/kubesampconACR/providers/Microsoft.Authorization/roleAssignments/4dc42cb8-e5de-4ede-8600-0092ec8e00c1",
  "name": "4dc42cb8-e5de-4ede-8600-0092ec8e00c1",
  "principalId": "4fa185aa-a96f-40cb-9c47-ec57f22cb018",
  "resourceGroup": "kubesampRG",
  "roleDefinitionId": "/subscriptions/5f4d7b4b-0b36-429b-acb5-b14b444a9fd0/providers/Microsoft.Authorization/roleDefinitions/7f951dda-4ed3-4680-a7ca-43fe172d538d",
  "scope": "/subscriptions/5f4d7b4b-0b36-429b-acb5-b14b444a9fd0/resourceGroups/kubesampRG/providers/Microsoft.ContainerRegistry/registries/kubesampconACR",
  "type": "Microsoft.Authorization/roleAssignments"
}

13) Create Kubernetes cluster
az aks create --resource-group kubesampRG --name kubecluster --node-count 1 --service-principal <Entity Service AppId> --client-secret <Entity Service password> --generate-ssh-keys

az aks create --resource-group kubesampRG --name kubecluster --node-count 1 --service-principal XXXXXXX-3c5d-43b7-ace4-29be342bb171 --client-secret YYYYYY-66ae-4713-9769-4b754a482539 --generate-ssh-keys

Output:
SSH key files 'C:\Users\sysadmin\.ssh\id_rsa' and 'C:\Users\sysadmin\.ssh\id_rsa.pub' have been generated under ~/.ssh to allow SSH access to the VM. If using machines without permanent storage like Azure Cloud Shell without an attached file share, back up your keys to a safe location

14) *Only if you are using CLI from client machine, make sure Kubernetes CLI is installed
az aks install-cli

15) Connect into the cluster
az aks get-credentials --resource-group kubesampRG --name kubecluster

16) Get cluster node
kubectl get nodes

17) Create compose.yaml file, with this

apiVersion: apps/v1beta1
kind: Deployment
metadata:
  name: simplenode1
spec:
  replicas: 1
  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
  minReadySeconds: 5 
  template:
    metadata:
      labels:
        app: simplenode2
    spec:
      containers:
      - name: simplenode3
        image: kubesampconacr.azurecr.io/simplenode:v1
        ports:
        - containerPort: 80
        resources:
          requests:
            cpu: 250m
          limits:
            cpu: 500m
---
apiVersion: v1
kind: Service
metadata:
  name: simplenode-1we
spec:
  type: LoadBalancer
  ports:
  - port: 80
  selector:
    app: simplenode2

18) Implements the app
kubectl apply -f compose.yaml




```bash
NAMESPACE="cattle-system"
RELEASE="rancher"
HELM_REPO_NAME="rancher-stable"
HELM_REPO_URL="https://releases.rancher.com/server-charts/stable"
HELM_CHART="rancher"

helm repo add $HELM_REPO_NAME $HELM_REPO_URL
helm repo update

helm upgrade --install $RELEASE $HELM_REPO_NAME/$HELM_CHART \
    --devel \
    --namespace $NAMESPACE \
    --create-namespace \
    --values helm-configs/$NAMESPACE/$RELEASE/values.yaml
```
```bash
kubectl get all \
    --namespace $NAMESPACE
```
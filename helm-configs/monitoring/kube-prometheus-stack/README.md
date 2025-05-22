```bash
NAMESPACE="monitoring"
RELEASE="kube-prometheus-stack"
HELM_REPO_NAME="prometheus-community"
HELM_REPO_URL="https://metallb.github.io/metallb"
HELM_CHART="kube-prometheus-stack"

helm repo add $HELM_REPO_NAME $HELM_REPO_URL
helm repo update

helm upgrade --install $RELEASE $HELM_REPO_NAME/$HELM_CHART \
    --namespace $NAMESPACE \
    --create-namespace \
    --values helm-configs/$NAMESPACE/$RELEASE/values.yaml
```
```bash
kubectl get all \
    --namespace $NAMESPACE
```
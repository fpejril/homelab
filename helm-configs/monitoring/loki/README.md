```bash
NAMESPACE="monitoring"
RELEASE="loki"
HELM_REPO_NAME="grafana"
HELM_REPO_URL="https://grafana.github.io/helm-charts"
HELM_CHART="loki"

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
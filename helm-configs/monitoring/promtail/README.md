```bash
NAMESPACE="monitoring"
RELEASE="promtail"
HELM_REPO_NAME="grafana"
HELM_REPO_URL="https://grafana.github.io/helm-charts"
HELM_CHART="promtail"

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
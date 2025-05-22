```bash
NAMESPACE="ingress-nginx"
RELEASE="ingress-nginx"
HELM_REPO_NAME="ingress-nginx"
HELM_REPO_URL="https://kubernetes.github.io/ingress-nginx"
HELM_CHART="ingress-nginx"

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
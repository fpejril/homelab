```bash
NAMESPACE="metallb-system"
RELEASE="metallb"
HELM_REPO_NAME="metallb"
HELM_REPO_URL="https://metallb.github.io/metallb"
HELM_CHART="metallb"

helm repo add $HELM_REPO_NAME $HELM_REPO_URL
helm repo update

helm upgrade --install $RELEASE $HELM_REPO_NAME/$HELM_CHART \
    --namespace $NAMESPACE \
    --create-namespace \
    --values helm-configs/$NAMESPACE/$RELEASE/values.yaml

kubectl apply \
    --filename kube-configs/$NAMESPACE/crs.yaml
```
```bash
kubectl get all \
    --namespace $NAMESPACE
```
```bash
NAMESPACE="kubernetes-dashboard"
RELEASE="dashboard"
HELM_REPO_NAME="kubernetes-dashboard"
HELM_REPO_URL="https://kubernetes.github.io/dashboard/"
HELM_CHART="kubernetes-dashboard"

helm repo add $HELM_REPO_NAME $HELM_REPO_URL
helm repo update

helm upgrade --install $RELEASE $HELM_REPO_NAME/$HELM_CHART \
    --namespace $NAMESPACE \
    --create-namespace \
    --values helm-configs/$NAMESPACE/$RELEASE/values.yaml

kubectl apply \
    --filename kube-configs/$NAMESPACE/$RELEASE/crs.yaml
```
```bash
kubectl get all \
    --namespace $NAMESPACE
```
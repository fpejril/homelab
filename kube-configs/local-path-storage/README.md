```bash
NAMESPACE="local-path-storage"

kubectl apply \
    --filename https://raw.githubusercontent.com/rancher/local-path-provisioner/v0.0.31/deploy/local-path-storage.yaml
```
```bash
kubectl get all \
    --namespace $NAMESPACE
```
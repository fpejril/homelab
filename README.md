# fplabs-io/kubernetes

This repository contains Helm chart configurations and Kubernetes custom resource definitions used to deploy and manage services across the fplabs Kubernetes clusters.

## Overview

The repository is organized into two main directories:

- **`helm-configs/`** – Contains Helm value files and deployment instructions for managing services with Helm.
- **`kube-configs/`** – Contains Kubernetes manifests (typically CRDs or additional resource definitions) that supplement certain Helm deployments.

Each Helm deployment includes a `values.yaml` file for configuration and a `README.md` with instructions to install or upgrade the release.

## Directory Structure
```
helm-configs/
├── /
│   └── /
│       ├── README.md         # Installation instructions
│       └── values.yaml       # Helm values file

kube-configs/
├── /
│   └── crs.yaml              # Kubernetes manifests (CRDs, etc.)
```
### Examples

- `helm-configs/monitoring/kube-prometheus-stack/values.yaml` – Configuration for Prometheus & Grafana.
- `kube-configs/metallb-system/crs.yaml` – Layer 2 address pool config for MetalLB.

## Usage

### 1. Add Helm Repositories

Each service README will define which Helm repo to use. For example:

```bash
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
helm repo update
```

### 2. Install or Upgrade a Release

Use the provided command structure (from the service’s README.md) to install:

```bash
NAMESPACE="cattle-system"
RELEASE="rancher"
HELM_REPO_NAME="rancher-stable"
HELM_CHART="rancher"

helm upgrade --install $RELEASE $HELM_REPO_NAME/$HELM_CHART \
    --namespace $NAMESPACE \
    --create-namespace \
    --values helm-configs/$NAMESPACE/$RELEASE/values.yaml
```

### 3. Deploy Kubernetes Manifests

If a chart requires additional resources (such as CRs), apply them from kube-configs/:

```
kubectl apply -f kube-configs/<namespace>/crs.yaml
```

### Notes
- Each Helm chart lives in its own namespaced folder.
- You are encouraged to follow the same pattern when adding new charts or resources.
- This repo is environment-agnostic. Cluster-specific settings should go in the appropriate values.yaml files.

### Future Improvements
- Add CI validation for YAML syntax or Helm template linting.
- Define cluster-specific overlays using tools like kustomize or helmfile.


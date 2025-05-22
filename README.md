# fplabs-io/kubernetes

This repository centralizes all Helmfile-driven deployments and associated Kubernetes manifests for the fplabs clusters.

## Prerequisites

Make sure you have these tools installed and available in your `PATH`:

```bash
# macOS (Homebrew)
brew install helm helmfile kustomize

# Install the Helm Diff plugin for `helmfile diff`
helm plugin install https://github.com/databus23/helm-diff
```

> Note: Modern `kubectl` includes Kustomize via `kubectl kustomize`, but Helmfile’s chartify flow requires a standalone `kustomize` binary.

## Repository Layout

```
.
├── helm-configs/                  # Helm values for each chart
│   ├── cattle-system/rancher/
│   │   └── values.yaml
│   ├── ingress-nginx/ingress-nginx/
│   │   └── values.yaml
│   ├── kubernetes-dashboard/dashboard/
│   │   └── values.yaml
│   ├── metallb-system/metallb/
│   │   └── values.yaml
│   ├── monitoring/
│   │   ├── kube-prometheus-stack/values.yaml
│   │   ├── loki/values.yaml
│   │   └── promtail/values.yaml
│   └── open-webui/open-webui/
│       └── values.yaml
│
├── kube-configs/                  # Raw manifests or Kustomize directories
│   ├── kubernetes-dashboard/crs.yaml
│   ├── local-path-storage/        # Kustomize dir for local-path-provisioner
│   │   └── kustomization.yaml
│   └── metallb-system/crs.yaml
│
├── helmfile.yaml                  # Central declarative manifest
└── README.md
```

## Helmfile Workflow

All deployments—charts and Kustomize-based resources—are driven from `helmfile.yaml`.

1. **Sync repositories**  
   ```bash
   helmfile repos
   ```

2. **Preview changes**  
   ```bash
   helmfile diff
   ```

3. **Deploy or update everything**  
   ```bash
   helmfile apply
   ```

4. **Tear down all releases**  
   ```bash
   helmfile destroy
   ```

### Targeted operations

- Run only a specific release:  
  ```bash
  helmfile -l name=metallb apply
  ```
- Switch environments (once you convert to `.gotmpl`):  
  ```bash
  helmfile -e production apply
  ```

## Handling Raw Manifests

- **MetalLB & Dashboard CRs** are applied via `postsync` hooks in `helmfile.yaml`.
- **Local Path Provisioner** is managed as a Kustomize directory; its `Namespace` is stripped out so Helmfile’s `createNamespace: true` handles namespace creation.

## Example Releases

```yaml
releases:
  - name: metallb
    namespace: metallb-system
    chart: metallb/metallb
    version: 0.14.9
    values:
      - helm-configs/metallb-system/metallb/values.yaml
    hooks:
      - events: ["postsync"]
        showlogs: true
        command: kubectl
        args:
          - apply
          - -f
          - kube-configs/metallb-system/crs.yaml

  - name: local-path-provisioner
    namespace: local-path-storage
    createNamespace: true
    chart: kube-configs/local-path-storage
```

## Future Enhancements

- **CI Integration:** Add linting and `helmfile diff` checks on pull requests.
- **Environment Overlays:** Move to a templated `helmfile.yaml.gotmpl` for distinct `dev`/`staging`/`prod` settings.
- **Shared Templates:** Extract common release patterns into Go templates within Helmfile.
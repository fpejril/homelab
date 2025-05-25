# Notes

## Traefik and MetalLB
Traefik's helm release by default depends on being able to acquire a load balancer IP. For this reason, MetalLB and its configurations must be applied prior to the installation of traefik.

## FluxCD Staging Configuration

In FluxCD I have:

```
# clusters/staging/infrastructure.yaml:
---
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: infra-controllers
  namespace: flux-system
spec:
  interval: 1h
  retryInterval: 1m
  timeout: 5m
  sourceRef:
    kind: GitRepository
    name: flux-system
  path: ./infrastructure/staging/controllers
  prune: true
  wait: true
```

### infra-controllers

The structure of the target path is:

```
❯ tree ./infrastructure/staging/controllers                                                                                                         ─╯
./infrastructure/staging/controllers
├── disable-longhorn.yaml
└── kustomization.yaml

0 directories, 2 files
```

For which we have

```
# infrastructure/staging/controllers/disable-longhorn.yaml
apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: longhorn
  namespace: longhorn-system
$patch: delete
```

```
# infrastructure/staging/controllers/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
# namespace: longhorn
resources: 
  - ../../base/controllers
patches:
  - path: disable-longhorn.yaml
    target:
      kind: HelmRelease
      name: longhorn
      namespace: longhorn-system
```

## FluxCD Base Configuration

### infra-controllers

Then I have

```
infrastructure/base/controllers
├── cert-manager.yaml
├── kustomization.yaml
├── longhorn.yaml
├── metallb.yaml
└── traefik.yaml

0 directories, 5 files
```

with

```
# infrastructure/base/controllers/cert-manager.yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: cert-manager
---
apiVersion: source.toolkit.fluxcd.io/v1
kind: HelmRepository
metadata:
  name: cert-manager
  namespace: cert-manager
spec:
  interval: 24h
  url: https://charts.jetstack.io
---
apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: cert-manager
  namespace: cert-manager
spec:
  interval: 30m
  chart:
    spec:
      chart: cert-manager
      version: "1.x"
      sourceRef:
        kind: HelmRepository
        name: cert-manager
        namespace: cert-manager
      interval: 12h
  values:
    crds:
      enabled: true
      keep: true
```

```
# infrastructure/base/controllers/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - cert-manager.yaml
  - longhorn.yaml
  - metallb.yaml
  - traefik.yaml
```

```
# infrastructure/base/controllers/longhorn.yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: longhorn-system
---
apiVersion: source.toolkit.fluxcd.io/v1
kind: HelmRepository
metadata:
  name: longhorn
  namespace: longhorn-system
spec:
  interval: 24h
  url: https://charts.longhorn.io
---
apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: longhorn
  namespace: longhorn-system
spec:
  interval: 30m
  chart:
    spec:
      chart: longhorn
      version: "1.x"
      sourceRef:
        kind: HelmRepository
        name: longhorn
        namespace: longhorn-system
      interval: 12h
```

```
# infrastructure/base/controllers/metallb.yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: metallb-system
---
apiVersion: source.toolkit.fluxcd.io/v1
kind: HelmRepository
metadata:
  name: metallb
  namespace: metallb-system
spec:
  interval: 24h
  url: https://metallb.github.io/metallb
---
apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: metallb
  namespace: metallb-system
spec:
  interval: 30m
  chart:
    spec:
      chart: metallb
      version: "0.x"
      sourceRef:
        kind: HelmRepository
        name: metallb
        namespace: metallb-system
      interval: 12h
```

```
# infrastructure/base/controllers/metallb.yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: traefik
---
apiVersion: source.toolkit.fluxcd.io/v1
kind: HelmRepository
metadata:
  name: traefik
  namespace: traefik
spec:
  interval: 24h
  url: https://traefik.github.io/charts
---
apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: traefik
  namespace: traefik
spec:
  interval: 30m
  chart:
    spec:
      chart: traefik
      version: "35.x"
      sourceRef:
        kind: HelmRepository
        name: traefik
        namespace: traefik
      interval: 12h
```

## Questions

### How does FluxCD interpret this?

My understanding is that the staging configuration on top of the base will simply ensure that all base configurations are included, except for the longhorn Helm Release as a result of `infrastructure/staging/controllers/disable-longhorn.yaml`. Is my understanding correct?

### How does `infrastructure/base/controllers/kustomization.yaml` augment the behavior of the other yaml files in `infrastructure/base/controllers`? 
When I define `infrastructure/staging/controllers/kustomization.yaml`, it creates a kustomization pointing to `infrastructure/base/controllers`. 
1. Does this kustomization only read the `kustomization.yaml` in that directory (and why?)?
2. I am not able to find documentation on the syntax of `$patch: delete` used in the staging kustomization. Where is this described, and how does it work?
3. What will flux do in the staging cluster using the staging kustomization? 
    - How can I figure this out using Flux?
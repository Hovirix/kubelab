# Kubelab

Talos, Kubernetes, and FluxCD implementation for the HX Lab homelab.

This repository is the source of truth for the Kubernetes platform, including:

- Proxmox virtual machines managed with OpenTofu
- Talos Linux cluster lifecycle management
- FluxCD GitOps
- Cilium networking
- Traefik
- cert-manager
- CloudNativePG and PostgreSQL resources
- Prometheus, Grafana, Loki, and Alloy

The GitHub repository is intentionally public. Keep only encrypted secrets in
Git and treat infrastructure topology and configuration as public information.

## Deploy

Enter the development shell before running tasks:

```bash
nix develop
```

Provision a fresh cluster, then bootstrap GitOps:

```bash
task cluster:init
task cluster:plan
task cluster:apply
task cluster:bootstrap
```

`cluster:bootstrap` installs Cilium, bootstraps Flux against this repository's
`main` branch, and installs the Flux SOPS key. Flux then reconciles
`platform/clusters/prod`.

The encrypted files in `secrets/` and the SOPS age private key are required.
The target environment must also provide the Proxmox, AdGuard, Cloudflare, R2,
and GitHub access configured by those encrypted secrets. The PostgreSQL cluster
requires a default StorageClass or an explicit storage class in
`platform/database/postgresql/cluster.yaml`.

To update already-bootstrapped GitOps state:

```bash
task cluster:reconcile
```

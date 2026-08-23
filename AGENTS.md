# Kubelab Instructions

## Scope

- `infrastructure/` declares the Proxmox VM, Talos cluster lifecycle, DNS, and encrypted OpenTofu inputs.
- `platform/` is Flux-managed Kubernetes state. `platform/clusters/prod` is the reconciliation root.
- `operations/` owns Task entrypoints and scripts; keep infrastructure and platform state out of it.
- Treat `secrets/**/*.sops.yaml` and `platform/**/*.sops.yaml` as encrypted inputs. Never add plaintext credentials or generated credentials to Git.
- This repository is intentionally public; topology and non-secret configuration are public information.

## Deployment And Safety

- Use `nix develop` so `TALOSCONFIG` and `KUBECONFIG` point at `.artifacts/talos/prod-k8s/`.
- A fresh deployment must run in order: `task cluster:init`, `task cluster:plan`, `task cluster:apply`, then `task cluster:bootstrap`.
- Bootstrap installs Cilium before Flux and the Flux SOPS key. Do not reorder those steps.
- Flux tracks `Hovirix/kubelab` `main` at `platform/clusters/prod`; keep `operations/scripts/bootstrap-flux.sh` and `platform/clusters/prod/flux-system/gotk-sync.yaml` aligned.
- `platform/clusters/prod/flux-system/gotk-components.yaml` and `gotk-sync.yaml` are Flux-generated bootstrap state. Do not edit them except when deliberately regenerating or updating the bootstrap source.
- Do not run `tofu apply`, `tofu destroy`, `task cluster:bootstrap`, `task cluster:reconcile`, or mutating `kubectl`/Flux/Helm commands without explicit user approval.

## Validation

- Run `task checks:all` for flake evaluation, ShellCheck, secret scanning, and TFLint.
- Run `task security:kubernetes` after platform manifest changes; run `task security:all` for the full security suite. SBOMs are generated under ignored `.artifacts/sbom/`.
- Format with `task checks:fmt`.
- CI runs `task checks:all` on pushes and pull requests, and `task security:all` on pull requests and weekly.

## Workflow

- Preserve the dependency order declared by Flux `Kustomization` resources when changing platform components.
- Commit subjects use `<type>(<domain>): <change>` with lowercase imperative text; keep unrelated changes separate.
- Use the project OpenCode agent boundaries in `.opencode/agents/`; request Security review for secrets, RBAC, identity, exposure, permissions, or destructive changes.

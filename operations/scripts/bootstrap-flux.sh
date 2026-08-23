#!/usr/bin/env bash

set -euo pipefail

flux bootstrap github \
  --owner=hovirix \
  --repository=kubelab \
  --branch=main \
  --path=platform/clusters/prod \
  --personal \
  --private=false

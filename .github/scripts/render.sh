#!/usr/bin/env bash
# Render every Flux Kustomization in a checkout to <out>/<name>.yaml.
# usage: render.sh <checkout-dir> <out-dir>
set -uo pipefail
src=$(realpath "$1"); out=$(mkdir -p "$2" && realpath "$2")
cd "$src"
kubectl kustomize flux > "$out/_root.yaml" 2> "$out/_root.err" || true
# every Flux Kustomization (kind + path) found in the root build, except flux-system itself
yq -r 'select(.kind == "Kustomization" and .apiVersion == "kustomize.toolkit.fluxcd.io/v1") | .metadata.name + " " + .spec.path' "$out/_root.yaml" 2>/dev/null |
while read -r name path; do
  [ -z "${path:-}" ] || [ "$name" = flux-system ] && continue
  [ -d "$path" ] || { echo "path $path not found in this checkout" > "$out/$name.yaml"; continue; }
  kubectl kustomize "$path" > "$out/$name.yaml" 2>&1 || echo "# BUILD FAILED" >> "$out/$name.yaml"
done
rm -f "$out/_root.err"

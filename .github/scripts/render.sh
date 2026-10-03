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
  [ "$path" = ./flux ] && continue   # same as _root
  [ -d "$path" ] || { echo "path $path not found in this checkout" > "$out/$name.yaml"; continue; }
  build_dir=$path
  if [ ! -e "$path/kustomization.yaml" ]; then
    # Flux generates a kustomization for directories without one; emulate that
    build_dir=$(mktemp -d); cp -r "$path/." "$build_dir"
    (cd "$build_dir" && kustomize create --autodetect --recursive >/dev/null 2>&1)
  fi
  kubectl kustomize "$build_dir" > "$out/$name.yaml" 2>&1 || echo "# BUILD FAILED" >> "$out/$name.yaml"
done
rm -f "$out/_root.err"

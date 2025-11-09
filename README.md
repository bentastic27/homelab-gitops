# homelab-gitops

# RKE2 / Ubuntu 24.04 prereqs

`/etc/rancher/rke2/config.yaml` content:

```
tls-san:
- lab.beansnet.net
- remotek8s.beansnet.net
- "192.168.1.10"
disable: rke2-ingress-nginx
disable-cloud-controller: true
```

## Init

```
istioctl install -f flux/istio/istio-operator.yaml

kubectl create ns flux

# init cert manager IAM
echo -n access-key-id > accessKeyId
echo -n secret-access-key > secretAccessKey
kubectl -n flux create secret generic route53-credentials-secret --from-file=accessKeyId --from-file=secretAccessKey

# oath2-proxy secret:
# https://github.com/settings/developers
echo -n clientid > OAUTH2_PROXY_CLIENT_ID
echo -n clientsecret > OAUTH2_PROXY_CLIENT_SECRET
kubectl -n flux create secret generic github-oauth --from-file=OAUTH2_PROXY_CLIENT_ID --from-file=OAUTH2_PROXY_CLIENT_SECRET 

# init restic password for minecraft backups
kubectl -n flux create secret generic restic-password --from-literal=RESTIC_PASSWORD=$(openssl rand -hex 10)

flux bootstrap -n flux github \
  --owner=bentastic27 \
  --repository=homelab-gitops\
  --private=false \
  --personal=true \
  --path=flux
```

## Lenovo M715q

Disable C(6) states in bios.

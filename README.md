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
# https://console.cloud.google.com/auth/clients
echo -n clientid > OAUTH2_PROXY_CLIENT_ID
echo -n clientsecret > OAUTH2_PROXY_CLIENT_SECRET
echo -n google-admin-email > OAUTH2_PROXY_GOOGLE_ADMIN_EMAIL
echo -n google-GROUP > OAUTH2_PROXY_GOOGLE_GROUP
kubectl -n flux create secret generic google-oauth \
  --from-file=OAUTH2_PROXY_CLIENT_ID \
  --from-file=OAUTH2_PROXY_CLIENT_SECRET \
  --from-file=OAUTH2_PROXY_GOOGLE_ADMIN_EMAIL \
  --from-file=OAUTH2_PROXY_GOOGLE_GROUP \
  --from-literal=OAUTH2_PROXY_COOKIE_SECRET=$(openssl rand -base64 32 | head -c 32)

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

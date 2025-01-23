# homelab-gitops

# RKE2 / Ubuntu 24.04 prereqs

`/etc/rancher/rke2/config.yaml` content:

```
tls-san:
- lab.beansnet.net
- "192.168.1.10"
disable: rke2-ingress-nginx
disable-cloud-controller: true
```

## Init

```
kubectl create ns flux

# init cert manager IAM
echo -n access-key-id > accessKeyId
echo -n secret-access-key > secretAccessKey
kubectl -n flux create secret generic route53-credentials-secret --from-file=accessKeyId --from-file=secretAccessKey

flux bootstrap -n flux github \
  --owner=bentastic27 \
  --repository=homelab-gitops\
  --private=false \
  --personal=true \
  --path=flux
```

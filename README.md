# homelab-gitops

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

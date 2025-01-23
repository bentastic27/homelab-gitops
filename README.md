# homelab-gitops

## Init

```
kubectl create ns flux

# init cert manager IAM
echo -n access-key-id > access-key-id
echo -n secret-access-key > secret-access-key
kubectl -n flux create secret generic route53-credentials-secret --from-file=access-key-id --from-file=secret-access-key

flux bootstrap -n flux github \
  --owner=bentastic27 \
  --repository=homelab-gitops\
  --private=false \
  --personal=true \
  --path=flux
```

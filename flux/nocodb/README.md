# NocoDB

Runs the `nocodb/nocodb` image at https://nocodb.int.beansnet.net (internal gateway only),
deployed alongside Baserow to compare the two. Postgres runs next to it from `manifests/`;
attachments are stored on the `nocodb-data` PVC.

## First login

The admin account is seeded on first boot from `nocodb-env` (`NC_ADMIN_EMAIL`, and a generated
password). Read the password with:

    kubectl -n nocodb get secret nocodb-env -o jsonpath='{.data.NC_ADMIN_PASSWORD}' | base64 -d

## Backups

k8up backs up the data PVC and a `pg_dumpall` of Postgres nightly to S3.

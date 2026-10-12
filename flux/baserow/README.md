# Baserow

Deployed from the official chart (`baserow.gitlab.io/baserow-chart`) at https://baserow.int.beansnet.net (internal gateway only).

Postgres and Valkey (Redis) run alongside the chart from `manifests/`; the chart's bundled
postgres, redis and caddy are disabled. MinIO from the chart stores user uploads and is
reached through `/files/` on the same hostname. Frontend (`/`), API (`/api/`) and websockets
(`/ws/`) are routed by `manifests/httproute.yaml`.

## First login

There is no seeded admin. The first account created at the sign-up page becomes the
instance admin, so register it right after the first deploy.

## Backups

k8up backs up the MinIO PVC and a `pg_dumpall` of Postgres nightly to S3.

# postgres-s3-backup-job

Automated backups for your dockerized postgres db.

Just add a container with your AWS keys and it will back up your database each hour in a nice folder configuration (split up by month). ie)

```
services:

  db:
    image: postgres:9.6
  
# Add these lines to automatically back up your db hourly.
  backup:
    image: countable:postgres-s3-backup-job:9.6
    environment:
      - BUCKET=countable/backups
      - SITE=test-site

```

This system currently assumes you have a postgres database service in docker-compose, called db. (or, at least the `db` name resolves to your database from within the backup container.

It also assumes you have s3 configured on your host (~/.aws exists from you having run `aws configure` before)

## Developing

To test:

Build the image, bring up a test db.
```
docker-compose build backup
docker-compose up -d db
```

Run a single backup.
```
docker-compose run backup /backup.sh
```

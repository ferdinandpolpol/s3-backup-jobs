# postgres-s3-backup-job

Automated backups for your dockerized postgres db.

You should first install awscli, and run aws configure. Ensure you can write to your backups directory.

```
pip install --user awscli
aws configure
touch test.txt
aws s3 cp test.txt countable/backups/test.txt
```

Just add a service as follows to docker-compose.yml and it will back up your database each hour in a nice folder configuration (split up by month). ie)

```
services:

  db:
    image: postgres:9.6
  
# Add these lines to automatically back up your db hourly.
  backup:
    build: .
    image: countable/s3-backup-job:1.0
    volumes:
      - $HOME/.aws/credentials:/root/.aws/credentials
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - BACKUP_BUCKET=countable/backups
      # Set to your server's docker API version.
      - DOCKER_API_VERSION=1.23
```

This system currently assumes you have a postgres database service in docker-compose, called db. (or, at least the `db` name resolves to your database from within the backup container.


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

Share to dockerhub.
```
docker push s3-backup-job:9.6
```

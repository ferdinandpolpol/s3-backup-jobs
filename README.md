# s3-backup-job

Automated backups for your dockerized db.

## Instructons

While you technically just need to create a `~/.aws/credentials` file, it's a good idea to install awscli, and run aws configure. Ensure you can write to your backups directory.

```
pip install --user awscli
aws configure
touch test.txt
aws s3 cp test.txt countable/backups/test.txt
```

With aws credentials tested, you can now add a service as follows to docker-compose.yml and it will back up your database each hour in a nice folder configuration (split up by month).

```
services:

  db:
    image: postgres:9.6
  
# Add these lines to automatically back up your db hourly.
  backup:
    image: countable/s3-backup-job:1.0
    volumes:
      - $HOME/.aws/credentials:/root/.aws/credentials
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      # Frequency for backups
      - BACKUP_FREQ=3600
      # S3 Bucket (and subpath) to put backups in.
      - BACKUP_BUCKET=countable/backups
      # Optional, command to generate your backup output. It must create a file or folder called `dump` in the root.
      - BACKUP_CMD=mongodump
      # Set to your server's docker API version. Run `docker version` to find this.
      - DOCKER_API_VERSION=1.23
```

This system currently assumes you have a database service in docker-compose, called db. (or, at least the `db` name resolves to your database from within the backup container. If you're using postgres (not mongodb), remove the `BACKUP_CMD` variable from the above lines. Other than that, the default options should work pretty well for you. For other databases, replace the BACKUP_CMD with a line that produces a file called `dump` as the backup output to store.


## Developing

Clone this repo.

To test the backups work.

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
docker push s3-backup-job:1.0
```

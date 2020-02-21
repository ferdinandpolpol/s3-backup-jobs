#!/bin/sh

set -e
set -x

if [ -z "$BACKUP_BUCKET" ]
then
  BACKUP_BUCKET=backups
  echo "BACKUP_BUCKET env var not specified, defaulting to the 'backups' bucket."
fi

if [ -z "$BACKUP_CMD" ]
then
   BACKUP_CMD="pg_dump -U postgres -f /dump postgres"
   echo "BACKUP_CMD env var not specified, defaulting to '${BACKUP_CMD}'."
fi

if [ -e $HOME/.aws/credentials ]
then
    echo "aws credentials found."
else
    echo "no ~/.aws/credentials file found. please mount one for me."
    exit 1
fi

site=$(docker ps --format '{{.Names}}' | grep _backup_ | cut -d'_' -f1) 
filename=$site.$(date +%Y%m%d-%H%M%S).sql
documentName=$site.$(date +%Y%m%d-%H%M%S)-OscarDocument
folder=$(date +%Y%m)

rm -rf /dump
rm -f /dump.lrz
rm -rf /documentsBackup
rm -f documents.tar

docker exec -t ${site}_db_1 rm -fr /dump
docker exec -t ${site}_db_1 $BACKUP_CMD
docker cp ${site}_db_1:/dump /dump
docker cp ${site}_tomcat_oscar_1:/var/lib/OscarDocument /documentsBackup/OscarDocument

tar cvf /dump.tar /dump
lrzip /dump.tar
rm -r /dump
tar cvf /documents.tar /documentsBackup 
lrzip /documents.tar
rm -rf /documentsBackup

aws s3 mv /dump.tar.lrz s3://$BACKUP_BUCKET/$site/$folder/$filename.tar.lrz
aws s3 mv /documents.tar s3://$BACKUP_BUCKET/$site/$folder/$documentName.tar.lrz


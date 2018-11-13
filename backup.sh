#!/bin/sh

set -e
set -x

if [ -z "$SITE" ]
then
  echo please set SITE env var to the name of your project.
  exit 1
fi

if [ -z "$BUCKET" ]
then
  BUCKET=backups
  echo "BUCKET env var not specified, defaulting to the 'backups' bucket."
fi

#if [ -z "$AWS_ACCESS_KEY_ID" ]
#then
#  echo please set AWS_ACCESS_KEY_ID.
#  exit 1
#fi

#if [ -z "$AWS_SECRET_ACCESS_KEY" ]
#then
#  echo please set AWS_SECRET_ACCESS_KEY.
#  exit 1
#fi

site=$SITE
filename=$site.$(date +%Y%m%d-%H%M%S).sql
folder=$(date +%Y%m)
rm -f /tmp/*.sql
rm -f /tmp/*.lrz
pg_dump -h db -U postgres -f /tmp/$filename postgres
lrzip /tmp/$filename
rm /tmp/$filename
aws s3 mv /tmp/$filename.lrz s3://$BUCKET/$site/$folder/$filename.lrz


#!bin/bash

set -e
set -x

if [ -e $HOME/.aws/credentials ]
then
    echo "aws credentials found."
else
    echo "no ~/.aws/credentials file found. please mount one for me."
    exit 1
fi

site=$(docker ps --format '{{.Names}}' | grep _backup_ | cut -d'_' -f1) 
filename=$site.$(date +%Y%m%d-%H%M%S)-OscarDocument
folder=$(date +%Y%m)

rm -rf /documentsBackup
rm -f documents.tar

docker cp -t ${site}_tomcat_oscar_1:/var/lib/OscarDocument /documentsBackup/OscarDocument

tar cvf /documents.tar /documentsBackup 
lrzip /documents.tar
rm -rf /documentsBackup

echo $site $filename $folder
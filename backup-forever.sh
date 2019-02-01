#!/bin/ash

set -euxo

BACKUP_FREQ="${BACKUP_FREQ:-3600}"

while true
do
    /backup.sh
    sleep $BACKUP_FREQ
done  

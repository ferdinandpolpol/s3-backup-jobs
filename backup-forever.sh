#!/bin/bash

set -euxo

FREQ="${FREQ:-3600}"

while true
do
    /backup.sh
    sleep $FREQ
done  

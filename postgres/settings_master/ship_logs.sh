#!/bin/sh
#
## This is called to back up the WAL files to the replica. 
## This is on top of replication and is used as another 
## method to secure data successfully transferring from one 
## database server to another.

ARCHIVE_DIR_ON_REPLICA ="/var/lib/postgresql/walfiles"
LOG=1
LOG_FILE="/tmp/postgres_wal_archiving.log"

log() { echo "`date --rfc-3339=ns` $1" >> "$LOG_FILE"; }
log_error() { echo "`date --rfc-3339=ns` $1" >> "$LOG_FILE"; exit 1; }

wal_path="$1"
wal_file="$2"
backup_server="10.5.0.6"

if [ $LOG -eq 1 ]
then
   log "Transfering file to backup server, filename: $wal_file"
fi

rsync -e "ssh -p 26" "$wal_path" "$backup_server:$ARCHIVE_DIR_ON_REPLICA"

if [ $LOG -eq 1 ]
then
   if [ "$?" -eq 0 ]; then
     log "Transfer to replica server completed"
   else
     log_error "Sending $wal_file failed."
   fi
fi

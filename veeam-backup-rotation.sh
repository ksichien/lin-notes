#!/bin/bash
REMOTEFOLDER="//dc1.internal.vandelayindustries.com/veeam-backups"
REMOTECREDS="/root/win-creds.txt"
LOCALMOUNT="/mnt/win-backups"

BACKUPJOB="Backup Job dc1"

LOCALFOLDERDAILY="/srv/rsync/backups/dc1/daily-backups"
LOCALFOLDERWEEKLY="/srv/rsync/backups/dc1/weekly-backups"
LOCALFOLDERMONTHLY="/srv/rsync/backups/dc1/monthly-backups"

DAILYLIMIT=7
WEEKLYLIMIT=31
MONTHLYLIMIT=180

# create a local file system of the remote folder
mount -t cifs ${REMOTEFOLDER} ${LOCALMOUNT} -o credentials=${REMOTECREDS}

TODAY=$(date +"%Y-%m-%d")
FILENAME=$(find "${LOCALMOUNT}/${BACKUPJOB}" -maxdepth 1 -name "${BACKUPJOB}${TODAY}*")
if [ $(date +"%u") = 7 ] # move to weekly folder for sundays
then
    rsync -avp "${FILENAME}" ${LOCALFOLDERWEEKLY}
else # move to daily folder for daily backups
    rsync -avp "${FILENAME}" ${LOCALFOLDERDAILY}
fi

# detach the remote folder's local file system
umount -v ${LOCALMOUNT}

# find the first full backup of the month and move it into the monthly folder
MONTH=$(date +"%Y-%m-")
FILENAME=$(find "${LOCALFOLDERWEEKLY}" -maxdepth 1 -name "${BACKUPJOB}${MONTH}[01-07]*.vbk")
if [ -n "${FILENAME}" ]
then
    mv -v "${FILENAME}" ${LOCALFOLDERMONTHLY}
fi

# remove old backups
find ${LOCALFOLDERDAILY} -maxdepth 1 -type f -mtime +${DAILYLIMIT} -exec rm -v {} \; # dailies older than 7 days
find ${LOCALFOLDERWEEKLY} -maxdepth 1 -type f -mtime +${WEEKLYLIMIT} -exec rm -v {} \; # weeklies older than 1 month
find ${LOCALFOLDERMONTHLY} -maxdepth 1 -type f -mtime +${MONTHLYLIMIT} -exec rm -v {} \; # monthlies older than 6 months

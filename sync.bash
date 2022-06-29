#!/bin/bash

set -euo pipefail

export BACKUP_ROOT=$(cd $(dirname ${0}) && pwd)

if [ ! -e ${BACKUP_ROOT}/config.bash ]; then
    echo ERROR: generate ${BACKUP_ROOT}/config.bash based on ${BACKUP_ROOT}/config.bash.sample
    exit 1
fi

if [ ! -e ${BACKUP_ROOT}/exclude.ptn ]; then
    echo ERROR: generate ${BACKUP_ROOT}/exclude.ptn based on ${BACKUP_ROOT}/exclude.ptn.sample
    exit 1
fi

YEAR=`date +%Y`
MONTH=`date +%m`
DAY=`date +%d`

source ${BACKUP_ROOT}/config.bash

export DEST_DIR=${BACKUP_ROOT}/data
export RSYNC_EXCLUDE_FILE=${BACKUP_ROOT}/exclude.ptn
export RSYNC_LOG_DIR=${BACKUP_ROOT}/log/${YEAR}/${MONTH}
export RSYNC_LOG_FILE=${RSYNC_LOG_DIR}/${DAY}.log

DIRSTR=`echo ${BACKUP_ROOT} | sed 's/\//\_/g'`
export LOCK_FILE=/tmp/${DIRSTR}_lock

if [ -e ${RSYNC_LOG_FILE} ] || [ -e ${RSYNC_LOG_FILE}.xz ] ; then
    RANDSTR=`date +%s | shasum | base64 | fold -w 5 | head -1`
    RSYNC_LOG_FILE=${RSYNC_LOG_FILE}_${RANDSTR}
fi

flock -x -n ${LOCK_FILE} /bin/bash ${BACKUP_ROOT}/sync_inner.bash

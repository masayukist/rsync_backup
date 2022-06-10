#!/bin/bash

set -euo pipefail

sync_inner_func () {
	DATE_START=`date`
	rsync ${RSYNC_OPT} --exclude-from=${RSYNC_EXCLUDE_FILE} ${ORIG_DIR} ${BACKUP_DIR}
	echo
	echo started : ${DATE_START}
	echo finished: `date`
}

mkdir -p ${RSYNC_LOG_DIR}
mkdir -p ${BACKUP_DIR}

sync_inner_func > ${RSYNC_LOG_FILE} 2>&1

xz ${RSYNC_LOG_FILE}

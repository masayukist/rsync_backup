#!/bin/bash

set -euo pipefail

if [ -z "$DEST_URI" ]; then
	export DEST_URI=${DEST_DIR}
fi

sync_inner_func () {
	DATE_START=`date`
	SYNC_CMD="rsync ${RSYNC_OPT} --exclude-from=${RSYNC_EXCLUDE_FILE} ${ORIG_DIR} ${DEST_URI}"
	echo ${SYNC_CMD}
	${SYNC_CMD}
	echo
	echo started : ${DATE_START}
	echo finished: `date`
}

mkdir -p ${RSYNC_LOG_DIR}
mkdir -p ${DEST_DIR}

sync_inner_func > ${RSYNC_LOG_FILE} 2>&1

xz ${RSYNC_LOG_FILE}

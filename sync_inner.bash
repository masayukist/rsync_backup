#!/bin/bash

set -euo pipefail

mkdir -p ${RSYNC_LOG_DIR}
mkdir -p ${BACKUP_DIR}
rsync ${RSYNC_OPT} --exclude-from=${RSYNC_EXCLUDE_FILE} ${ORIG_DIR} ${BACKUP_DIR} > ${RSYNC_LOG_FILE} 2>&1
xz ${RSYNC_LOG_FILE} 

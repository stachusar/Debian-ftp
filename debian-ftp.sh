￼#!/bin/bash

fatal() {
  echo "$1"
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | sudo tee -a /home/ubuntu/log/debianmirror-error.log >/dev/null
  exit 1
}

warn() {
  echo "$1"
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | sudo tee -a /home/ubuntu/log/debianmirror-error.log >/dev/null
}

check_mirror() {
  if ! ping -c 1 -W 2 `echo $RSYNCSOURCE | cut -d/ -f3` > /dev/null 2>&1; then
    fatal "Serwer lustrzany $RSYNCSOURCE jest niedostępny."
  fi
}

RSYNCSOURCE=rsync://ftp.cz.debian.org/debian/
BASEDIR=/srv/ftp/debianmirror/

check_mirror

if [ ! -d ${BASEDIR} ]; then
  warn "${BASEDIR} does not exist yet, trying to create it..."
  sudo mkdir -p ${BASEDIR} || fatal "Creation of ${BASEDIR} failed."
fi

sudo rsync -av --recursive --times --links --safe-links --hard-links \
  --stats \
  --exclude "Packages*" --exclude "Sources*" \
  --exclude "Release*" --exclude "InRelease" \
  ${RSYNCSOURCE} ${BASEDIR} >> /home/ubuntu/log/debianmirror.log 2>> /home/ubuntu/log/debianmirror-error.log || fatal "First stage of sync failed."

sudo rsync -av --recursive --times --links --safe-links --hard-links \
  --stats --delete --delete-after \
  ${RSYNCSOURCE} ${BASEDIR} >> /home/ubuntu/log/debianmirror.log 2>> /home/ubuntu/log/debianmirror-error.log || fatal "Second stage of sync failed."

sudo chown -R ubuntu:root ${BASEDIR}

date -u | sudo tee ${BASEDIR}/project/trace/$(hostname -f) >/dev/null


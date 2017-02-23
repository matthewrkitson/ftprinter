#!/bin/bash

PRINT_DIR=~/print
SYSLOG_TAG=ftprinter

function log {
  logger -s -t $SYSLOG_TAG "$1"
}

function error {
  log "$1"
  exit 1
}

if [ ! -d "$PRINT_DIR" ] ; then
  mkdir "$PRINT_DIR"
fi

files=$(ls -A "$PRINT_DIR")
if [ ! "$files" ] ; then
  # Nothing to do; exit early
  exit 0
fi

PRINT_TMP=$(mktemp -d) || error "Could not make temporary directory"
trap 'rm -rf $PRINT_TMP' EXIT

mv "$PRINT_DIR"/* "$PRINT_TMP" || error "Could not move files to temporary directory"

for file in "$PRINT_TMP"/*
do
  if [ -f "$file" ] ; then
    log "Printing $file"
    lpr "$file" || error "Error printing $file"
  fi
done

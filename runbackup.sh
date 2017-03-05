#!/usr/bin/env bash

set -e;

source env.sh;

export BORG_PASSPHRASE="$PASSPHRASE"

# Initialize the repository (or ignore if it's already initialized)
borg init $REPOSITORY || true;

# Perform backup
borg create -v \
	--compression lz4 \
	--stats \
	$REPOSITORY::'{hostname}-{now:%Y-%m-%d-%H-%M-%S}' \
	data;

# Prune files
borg prune -v \
	--list $REPOSITORY \
	--prefix '{hostname}-' \
	--keep-daily=${KEEP_DAILY:-7} \
	--keep-weekly=${KEEP_WEEKLY:-4} \
	--keep-monthly=${KEEP_MONTHLY:-6};

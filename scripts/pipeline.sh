#!/bin/bash
source config.sh
lockfile=$WORKDIR/run_pipeline.lock
cd $MY_REPO

if [ -f "$lockfile" ]; then
	echo "pipeline already running, started $(cat $lockfile)"
	exit
fi
date --iso-8601=minutes > $lockfile

# check if we have new sequences
if cmp $RKI_REPO/SARS-CoV-2-Sequenzdaten_Deutschland.fasta.xz $WORKDIR/SARS-CoV-2-Sequenzdaten_Deutschland.fasta.xz; then
        echo no new sequences received
        exit 1
fi

# we are ready to run
scripts/run_pangolin.sh |& tee $WORKDIR/run_pangolin.log


# cleanup & unlock next run
rm -rf $TEMPDIR/*
rm $lockfile

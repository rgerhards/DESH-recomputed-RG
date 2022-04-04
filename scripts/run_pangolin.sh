#!/bin/bash
source ~/bashrc_conda
cd "$RKI_REPO"
git checkout -f master
git pull

conda activate pangolin
cp SARS-CoV-2-Sequenzdaten_Deutschland.fasta.xz $WORKDIR
cd $WORKDIR
#TODO compute only new sequences!
# Note: due to haredware constraints, we do NOT do real parallel processing
#       for more capable environments, this shouldbe considered; if so, see "split" command
time unxz -k - < $WORKDIR/SARS-CoV-2-Sequenzdaten_Deutschland.fasta.xz |pangolin  --analysis-mode fast --tempdir "$TEMPDIR" -t$PANGOLIN_THREADS -
conda deactivate

#TODO error checking

rm -rf $DATADIR/lineage_report.csv.xz # just to be on the save side
# create new xz - TODO: rename earlier?
(      head -n 1 < $WORKDIR/lineage_report.csv \ | sed -e 's/^taxon,/IMS_ID,/'; \
       tail +2 < $WORKDIR/lineage_report.csv \
) | xz - > $DATADIR/lineage_report.csv.xz

# TODO move xz to repo after success!

#!/bin/bash

# A script to download a series of SRR numbers and save them into a source_data file

while IFS='' read -r SRR; do
	echo "$SRR"
	fasterq-dump "$SRR" -O source_data
done < $1

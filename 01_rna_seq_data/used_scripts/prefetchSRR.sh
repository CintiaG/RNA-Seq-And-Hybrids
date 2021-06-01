#!/bin/bash

# A script to download a series of SRR numbers and save them into the ncbi/public directory

while IFS='' read -r SRR; do
	echo "$SRR"
	prefetch $SRR
done < $1

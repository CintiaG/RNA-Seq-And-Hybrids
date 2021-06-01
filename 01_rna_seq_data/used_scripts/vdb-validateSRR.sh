#!/bin/bash

# A script to download a series of SRR numbers and save them into the ncbi/public directory

while IFS='' read -r SRR; do
	echo "$SRR"
	vdb-validate $SRR
done < $1

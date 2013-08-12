#! /bin/bash

find . -type f -exec cksum {} \; > 1.txt					# make a list of checksums for all files in the working directory
directory=`pwd`
rawcount=`wc -l 1.txt | cut -f 7 -d ' '`					# count the number of lines (no file name)
echo "There are $rawcount total files in $directory and its sub-directories."
#cut -f 1,2 -d ' ' 1.txt > 2.txt							# cut the text down to the checksums & file sizes only
#uniq 2.txt > 3.txt											# pull the unique entries
#wc -l 3.txt | cut -f 7 -d ' ' > 4.txt						# count the number of lines (no file name)

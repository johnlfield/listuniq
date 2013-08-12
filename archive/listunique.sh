#! /bin/bash

echo "Please type the file path you wish to search (full pathway from root):"
read path
cd $path
pathcheck=`pwd`

find . -type f \( ! -iname ".*" \) -exec cksum {} \; | sort > abcd.txt	# make a list of checksums for all files in the specified directory
rawcount=$(wc -l < abcd.txt | sed 's/ //g')								# count the number of lines, and report this only (skip the file name)
declare -i count
count=$rawcount-1														# subtract 1 for the working file just created
echo "There are $count total non-hidden files in $pathcheck and its sub-directories."

cut -f 1,2 -d ' ' abcd.txt > efgh.txt									# cut the text down to the checksums & file sizes only
##uniq 2.txt > 3.txt													# pull the unique entries
##wc -l 3.txt | cut -f 7 -d ' ' > 4.txt									# count the number of lines (no file name)

test=$(($count/3))
echo $test
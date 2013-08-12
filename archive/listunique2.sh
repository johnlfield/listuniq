#! /bin/bash

#input
echo "Please type the file path for the directory you wish to search (full pathway from root):"
read path
cd $path
pathcheck=`pwd`

#generating a checksum list and initial file counting 
find . -type f \( ! -iname ".*" \) -exec cksum {} \; | sort > 1.txt		#make a list of checksums for all files in the specified directory
rawcount=$(wc -l < 1.txt | sed 's/ //g')								#count the number of lines, and report this only (skip the file name)
declare -i count
count=$rawcount-1														#subtract 1 for the working file just created
echo "There are $count total non-hidden files in $pathcheck and its sub-directories."

#identifying unique checksums, create a unique list, a redundant list
cut -f 1,2 -d ' ' 1.txt > 2.txt											#cut the text down to the checksums & file sizes only
uniq -u 2.txt > 3.txt
grep -hif 3.txt 1.txt > uniq.txt													#list the unique entries
#uniq -d 2.txt > 4.txt													#list the redudant entries
ucount=$(wc -l < 3.txt | sed 's/ //g')
#grep -hif 1.txt 3.txt > uniq.txt

#displaying final output
percent=`echo "($ucount/$count)*100" | bc -l`
echo "Of those, $ucount files, or $percent % of the total, are unique"
echo "Unique filenames are listed in uniq.txt"
echo "Redundant filenames are listed in redun.txt"
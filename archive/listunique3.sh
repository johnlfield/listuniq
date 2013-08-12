#! /bin/bash

#input
echo "Please type the file path for the directory you wish to search (full pathway from root):"
read path
cd $path
pathcheck=`pwd`
cd ..
mkdir listuniq
cd listuniq

# #generate a checksum list and initial file count 
find $path -type f \( ! -iname ".*" \) -exec cksum {} \; | sort | sed "s:$path:.:g" > temp1.txt		#make a list of checksums for all files in the specified directory
count=$(wc -l < temp1.txt | sed 's/ //g')															#count the number of lines, and report this only (skip the file name)
echo "There are $count total non-hidden files in $pathcheck and its sub-directories."

#count unique checksums and list associated files
cut -f 1,2 -d ' ' temp1.txt | uniq > temp2.txt						#cut the text fields down to the checksums & file sizes only, find unique entries
grep -hif temp2.txt temp1.txt > uniq.txt							#match unique checksums to original entries, report file names only
ucount=$(wc -l < uniq.txt | sed 's/ //g')							#count the number of lines, and report this only (skip the file name)
# | cut -f 3,4,5,6,7,8 -d ' ' | sed 's/$path//g'

#count redundant checksums and list associated files
cut -f 1,2 -d ' ' temp1.txt | uniq -d > temp3.txt					#cut the text fields down to the checksums & file sizes only, find unique entries
grep -hif temp3.txt temp1.txt > redun.txt							#match unique checksums to original entries, report names only (with './' removed)

#displaying final output
percent=`echo "($ucount/$count)*100" | bc -l`
echo "Of those, $ucount files, or $percent % of the total, are unique"
echo "Unique filenames are listed in uniq.txt"
echo "Redundant filenames are listed in redun.txt"

#temporary file cleanup
#rm temp1.txt temp2.txt temp3.txt

#the mechanics of this work, but we run into a fundamental problem of trying to grep non-unique checksums back to the file names.
#alternate approach:  reorder the file, and use teh uniq -F=1 option
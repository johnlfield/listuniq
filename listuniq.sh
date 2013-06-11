#! /bin/bash

#input
echo ""
echo "This program counts and lists the files with unique and duplicate content within a directory."
echo "Note that the file pathways and names must NOT contain any spaces for the search to work correctly."
echo "Please type the file path for the directory you wish to search (full pathway from root):"
read path
cd $path
pathcheck=`pwd`
cd ..
mkdir listuniq
cd listuniq

# #generate a checksum list and initial file count 
find $path -type f \( ! -iname ".*" \) -exec cksum {} \; | sort | sed "s:$path:.:g" > abcd.txt		#make a list of checksums for all non-hidden files in the specified directory and sub-directories, sort it, simplify the file paths, and save as a temporary file
count=$(wc -l < abcd.txt | sed 's/ //g')									#count the number of lines, and report this only (skip the file name and extra spaces)
echo "There are $count total non-hidden files in $pathcheck and its sub-directories."

#count unique checksums and list associated files
rev abcd.txt | sort -k 2 | uniq -f 1 | rev | sort > uniq.txt				#reverse the list entries, sort on checksum, identify unique (skipping file name field), reverse & sort, and save
ucount=$(wc -l < uniq.txt | sed 's/ //g')									#count the number of lines, and report this only (skip the file name and extra spaces)
# | cut -f 3 -d ' ' | sed 's:./::g'											#piping this in at the end of line 20 would produce a list of file names (no checksum, bytecount, or path)
 
#count redundant checksums and list associated files
cut -f 1,2 -d ' ' abcd.txt | uniq -d | grep -hif - abcd.txt > redun.txt		#cut the text fields down to the checksums & file sizes only, find duplicate entries, match to original list (1-to-many), and save
 
#displaying final output
percent=`echo "($ucount/$count)*100" | bc -l`
echo "Of those, $ucount files, or $percent % of the total, are unique"
echo "Unique files are listed in ../listuniq/uniq.txt"
echo "Sets of redundant files are listed in ../listuniq/redun.txt"

#temporary file cleanup
rm abcd.txt

#this comment is just a test of the Github commit/push process
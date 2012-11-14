#!/bin/sh
for i in 48 68 49 50 49 49 49 50 0 47 0 0;
do 
	echo $i | awk '{printf("%c",$1)}';
done

#! /bin/bash

for d in `ls -la | grep ^d | awk '{print $NF}' | egrep -v '^\.'`; do

  e=`head -n 1 $d/README.md | sed 's/# //g' | awk -F'-' '{print $2}'`
  
  ./build.sh $d

  ./readme.sh $d $e

  ./folder.sh $d

done

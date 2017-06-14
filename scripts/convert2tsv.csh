#!/bin/csh

if( $#argv == 0 )then
  echo "Usage: "
  echo "    convert2tsv.csh file"
  exit
else
  set file = $argv[1]
endif

set tablename = `echo $file | cut -d '.' -f 1`

#echo $file $tablename
# Following line no longer needed, input data should be tab delimited now. We jsut need to remove #
#cat ${file} | grep -v '#' | sed 's/;/	/g;s/"/\&quot;/g' | sed "s/\&quot;/''/g" > ${tablename}.tsv
grep -v "#" $file > ${tablename}.tsv


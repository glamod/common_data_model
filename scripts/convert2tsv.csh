#!/bin/csh

if( $#argv == 0 )then
  echo "Usage: "
  echo "    convert2tsv.csh file"
  exit
else
  set file = $argv[1]
endif

set tablename = `echo $file | cut -d '.' -f 1`

echo $file $tablename

cat ${file} | grep -v '#' | sed 's/;/	/g' > ${tablename}.tsv

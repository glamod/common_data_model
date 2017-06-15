#!/bin/csh

#  fix_case.csh
#  
#
#  Created by dyb on 15/06/2017.
#

if( $#argv == 0) then
  echo "  Usage: "
  echo "    fix_case.csh file"
  exit
else
  set infile = $argv[1]
endif

set tablename = `echo $infile | cut -d '.' -f 1`
set new_table_name = `echo $tablename | awk 'BEGIN{ FS="\t" };{ \
  for( i = 1 ; i <= 1 ; i++ ){ \
  gsub("[[:upper:]]", "_&", $i); \
  $i = tolower( $i ); \
  gsub( "_i_d", "_id", $i); \
  sub( "^_" , "" ,$i); \
  gsub( "c_r_s", "crs", $i); \
  printf "%s", $i; \
  }\
 }'`

awk 'BEGIN{ FS="\t"} ; \
        { \
          for( i = 1; i <= NF - 1 ; i++){ \
            gsub( "[[:upper:]]", "_&", $i  ); \
            $i = tolower( $i ); \
            gsub( "_i_d", "_id", $i); \
            sub( "^_" , "" ,$i); \
            gsub( "(s)\t", "\t", $i); \
            gsub( "c_r_s", "crs", $i); \
            gsub( "w_i_g_o_s","wigos", $i); \
            printf "%s\t", $i \
          } \
          printf "%s\n", $i\
        }' $infile > $new_table_name.csv

mv $infile $infile.bak





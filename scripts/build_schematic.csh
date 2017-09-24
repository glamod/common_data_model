#!/bin/csh

# First get name of file to process
if( $#argv == 0)then
  echo "Usage: "
  echo "    build_schematic.csh <filename>"
  exit
else
  set file = $argv[1]
endif

# set table name
set tablename = `echo $file | cut -d '.' -f1`

# get number of columns - this should be 4
set ncols = `head -n 3 $file | tail -1 | awk 'BEGIN {FS="\t"} ; {print NF}'`



# print out rows
#echo "digraph $tablename {" >> nodes.gv
echo "node [color=white]" >> nodes.gv
echo $tablename '[label=<<TABLE BORDER="0" CELLBORDER="1" CELLSPACING="2" COLOR="BLACK">' >> nodes.gv
echo '<TR><TD COLSPAN="'$ncols'" ALIGN="left" PORT="head">Table: '$tablename'</TD></TR>' >> nodes.gv
echo '<TR><TD COLSPAN="'$ncols'" ALIGN="left">URL:https://raw.githubusercontent.com/glamod/common_data_model/master/tables/'$tablename'.dat</TD></TR>' >> nodes.gv
awk -v tablename="$tablename" 'BEGIN{FS="\t"} \
{\
  if( NR > 3){\
  printf "<TR>";\
  # print element name and port \
  printf "<TD PORT=\"%s_left\">%s</TD>;",$1, $1;\
  # print kind \
  printf "<TD>%s</TD>", $2;\
  # determine if external link \
  if( length( $3 ) > 1 ){ \
    printf "<TD>%s</TD>", $3; \
    printf "%s:%s_right -> %s_left ;\n", tablename, $1, $3  >> "edges.gv" \
    print length($3) \
  }else{\
    printf "<TD></TD>";\
  }\
  # print description and port \
  printf "<TD PORT=\"%s_right\">%s</TD>",$1, $4;\
  printf "</TR>\n";\
  }else if( NR == 3){ \
    printf "<TR><TD BGCOLOR=\"GRAY\">%s</TD><TD BGCOLOR=\"GRAY\">%s</TD><TD BGCOLOR=\"GRAY\">%s</TD><TD BGCOLOR=\"GRAY\">%s</TD></TR>\n", $1, $2, $3, $4 ;\
  }\
}\
' $file >> nodes.gv

echo "</TABLE>>]" >> nodes.gv
#echo "}" >> nodes.gv

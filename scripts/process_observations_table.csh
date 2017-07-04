#!/bin/csh
if( $#argv == 0)then
  echo "Usage: "
  echo "    process_table.csh <filename>"
  exit
else
  set file = $argv[1]
endif

# get name of table
set tablename = `echo $file | cut -d '.' -f1`

# get number of columns based on header row
set ncols = `awk 'BEGIN {FS="\t"} ; /^value/ || /^element_number/ {print NF}' $file`

# get column containing the external table
set extTable = `cat $file | grep "external_table" | awk -F"\t" '{for(i = 1; i <=NF ; i++){if ( $i ~ /external_table/ ){print i} }}'`

# print out rows
echo "digraph $tablename {" > ${tablename}.gv
echo "node [color=white]" >> ${tablename}.gv
echo $tablename '[label=<<TABLE BORDER="0" CELLBORDER="1" CELLSPACING="0" CELLPADDING="5" COLOR="BLACK">' >> ${tablename}.gv
echo '<TR><TD COLSPAN="'$ncols'" ALIGN="left" PORT="head"># Table: '$tablename'</TD></TR>' >> ${tablename}.gv
echo '<TR><TD COLSPAN="'$ncols'" ALIGN="left"># URL: https://github.com/DavidBerryNOC/C3S_311a_CDM/blob/master/tables/tsv/'$tablename'.tsv</TD></TR>' >> ${tablename}.gv
awk -v ncols="$ncols" -v extcolumn="$extTable" '\
BEGIN { FS="\t"  } ; \
  /^#/ {print "<TR><TD ALIGN=\"left\" COLSPAN=\""ncols"\">"$0"</TD></TR>"} \
  /^value/ || /^element_number/ {{printf "<TR>"};{for(i=1;i<=NF;i++){printf "<TD BGCOLOR=\"GRAY\">%s<\/TD>", $i };printf "<\/TR>\n" }} \
  /^[^#]/ && /^[^value]/ && /^[^element_number]/ { \
      {printf "<TR>"};{ \
      printf "<TD PORT=\"%sL\">%s</TD>",$2, $1 \
      for(i=2;i<=NF;i++){ \
        if( i == extcolumn && length($i) > 1 ){ \
          printf "<TD HREF=\"https://github.com/DavidBerryNOC/C3S_311a_CDM/blob/master/tables/tsv/%s.tsv\">",$i \
          printf "<FONT color=\"blue\">" \
        } \
        else if(i == NF) {\
          printf "<TD PORT=\"%sR\">", $2 \
        } \
        else {\
          printf "<TD>" \
        } \
        nwords = split( $i, words, " "); \
        for(j = 1; j <= nwords ; j++){ \
          printf "%s ", words[j]  \
          if( j % 10 == 0)printf "<BR/>" \
        }; \
        if( i == extcolumn && length($i) > 1 )printf "</FONT>" \
        printf "</TD>"\
        } \
      printf "<\/TR>\n" \
      }}' $file  >> ${tablename}.gv

# end table / node
echo "</TABLE>>];" >> ${tablename}.gv
echo "}" >> ${tablename}.gv


# now replace special characters (move to awk commands)
# ohm Ω
# degree
# ampersand
cat ${tablename}.gv | sed 's/°/\&deg;/g;s/Ω/\&#8486;/g;s/\& /\&amp; /g' > tmp.gv
mv tmp.gv ${tablename}.gv

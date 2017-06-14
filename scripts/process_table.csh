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
set ncols = `awk 'BEGIN {FS=";"} ; /^Value/ {print NF}' $file`

# print out rows
echo "digraph $tablename {"
echo "node [color=white]"
echo $tablename '[label=<<TABLE BORDER="0" CELLBORDER="1" CELLSPACING="2" COLOR="BLACK">'
echo '<TR><TD COLSPAN="'$ncols'" ALIGN="left"># Table: '$tablename'</TD></TR>'
echo '<TR><TD COLSPAN="'$ncols'" ALIGN="left"># URL: https://github.com/DavidBerryNOC/C3S_311a_CDM/blob/master/tables/'$tablename'.csv</TD></TR>'
awk -v ncols="$ncols" '\
BEGIN { FS=";"  } ; \
  /^#/ {print "<TR><TD ALIGN=\"left\" COLSPAN=\""ncols"\">"$0"</TD></TR>"} \
  /^Value/ {{printf "<TR>"};{for(i=1;i<=NF;i++){printf "<TD BGCOLOR=\"GRAY\">%s<\/TD>", $i };printf "<\/TR>\n" }} \
  /^[^#]/ && /^[^Value]/ {{printf "<TR>"};{for(i=1;i<=NF;i++){printf "<TD>%s<\/TD>", $i };printf "<\/TR>\n" }}' $file

# end table / node
echo "</TABLE>>];"
echo "}"


# now replace special characters
# ohm
# degree

#!/bin/csh
if( $#argv == 0)then
  echo "Usage: "
  echo "    process_table.csh <filename>"
  exit
else
  set file = $argv[1]
endif

# get name of table
set tablename = `echo $file | cut -d '.' -f1 | sed "s/_/ /g" | awk '{print toupper(substr($0,1,1)) tolower(substr($0,2)) }'`

# get number of columns based on header row
set ncols = `awk 'BEGIN {FS="\t"} ; /^Value/ || /^ElementNumber/ {print NF}' $file`

set tablepath="/Users/dyb/GitHub/C3S_311a_CDM/tables/"

# awk  -v ncols="$ncols" -v tablename="$tablename" -v file="$file" -v tablepath=$"tablepath" '\
awk -v ncols="$ncols" -v tablename="$tablename" -v file="$file" -v tablepath="$tablepath" '\
BEGIN { FS = "\t" ; \
    print "\\pgfplotstabletypeset[";\
    print "    empty header,";\
    print "    begin table=\\begin{longtable},";\
    print "    every head row/.style={output empty row},";\
    print "    every nth row={1}{before row=\\hline},";\
    print "    every first row/.append style={";\
    print "        before row={%";\
    print "            % Initial caption";\
   printf "            \\caption{%s}\n" , tablename;\
    print "            \\label{tab:DataTable}\\\\";\
    print "            % Initial column headers";\
}\
/^Value/ || /^ElementNumber/ {\
    printf "            \\hline\\hline " \
    for( i = 1; i < NF ; i ++) { \
        printf "\\multicolumn{1} { > {\\centering}V{2 in}} { \\textbf{%s}} &", $i \
    } \
    printf " \\multicolumn{1} { > {\\centering} V{4 in} } {\\textbf{%s}} \\\\ \\hline\\hline \\endfirsthead\n", $i; \
    printf "            \\multicolumn{%d}{c}{Table \\thetable\\ %s (cont.)} \\\\\n", ncols, tablename;\
    print "            % column headers on additional pages";\
    printf "            \\hline\\hline " \
    for( i = 1; i < NF ; i ++) { \
        printf "\\multicolumn{1} { > {\\centering}V{2 in} } { \\textbf{%s}} &", $i \
    } \
    printf " \\multicolumn{1} { > {\\centering} V{4 in} } {\\textbf{%s}} \\\\ \\hline\\hline \\endhead\n", $i; \
    print "            % Footer on 1st to penultimate pages";\
    printf "            \\multicolumn{%d}{r}{{Continued on next page}} \\\\\n", ncols;\
    print "            \\endfoot";\
    print "            % Footer on last page of table";\
    print "            \\hline";\
    printf "            \\multicolumn{%d}{r}{{End of table}} \\\\ \n", ncols;\
    print "            \\endlastfoot";\
    print "        }";\
    print "    },";\
    print "    %";\
    print "    end table=\\end{longtable},";\
    print "    col sep=tab,";\
    print "    string type,";\
    for( i = 1 ; i < NF ; i ++){\
        printf "    columns/%s/.style={\n", $i;\
        print "            string type, ";\
        print "            column type= V{2 in}, ";\
        print "            string replace*={_}{}";\
        print "        },";\
    }\
    printf "    columns/%s/.style={\n", $i;\
    print "            string type, ";\
    print "            string replace*={_}{},";\
    print "            column type = V{4 in}";\
    print "        }";\
    printf "    ]{%s%s}\n", tablepath, file ;\
} \
' $file

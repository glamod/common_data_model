#!/bin/csh
#
# Script to read in tab separated file containing table definition for common data model and write out
# Latex code for inclusion of table in Latex document.

# Check usage
if( $#argv == 0)then
  echo "Usage: "
  echo "    process_table_def.csh <filename>"
  exit
else
  set file = $argv[1]
endif

# get name of table to process

# get name of table and caption
set tablename = `echo $file | cut -d '.' -f1`
set tablecaption = `echo $file | cut -d '.' -f1 | sed "s/_//g" | awk '{print toupper(substr($0,1,1)) tolower(substr($0,2)) }'`
set tablesource = `grep '^# Source:' $file | sed 's/^# Source://g'`

# get number of columns based on header row
set ncols = `head -3 $file | tail -1 | awk 'BEGIN {FS="\t"} ; {print NF}'`

set tablepath="../table_definitions/"

# awk  -v ncols="$ncols" -v tablename="$tablename" -v file="$file" -v tablepath=$"tablepath" '\
head -n 3 $file | tail -1 | awk -v ncols="$ncols" -v tablecaption="$tablecaption" -v tablename="$tablename" -v file="$file" -v tablepath="$tablepath" -v tablesource="$tablesource" '\
BEGIN { FS = "\t" ; \
    lflag = 0 ; \
    if( ncols > 4){\
      if( tablename !~ /configuration$/ && tablename !~ "header_table" && tablename != "observations_table" && tablename != "observed_variable"){ \
        lflag = 1 ; \
        print "\\begin{landscape}";\
      } \
      pagewidth = 8.5;\
    }else{\
      pagewidth = 6.8;\
    }\
    gsub(/_/,"\\_",tablename); \
    colwidth = (pagewidth-4.0) / (ncols - 1.0) ;\
    print "\\pgfplotstabletypeset[";\
    print "    empty header,";\
    print "    begin table=\\begin{longtable},";\
    print "    %every head row/.style={output empty row},";\
    print "    every nth row={1}{before row=\\hline},";\
    print "    every first row/.append style={";\
    print "        before row={%";\
    print "            % Initial caption";\
    if( length( tablesource ) > 1 ){\
      printf "            \\caption{%s (%s)}\n" , tablename, tablesource;\
    }else{\
      printf "            \\caption{%s}\n" , tablename;\
    }\
   printf "            \\label{tab:DataTable%s}\\\\\n", tablecaption;\
    print "            % Initial column headers";\
}\
{\
    printf "            \\hline\\hline " \
    for( i = 1; i < NF ; i ++) { \
        entry = $i;\
        gsub(/_/,"\\_",entry);\
        printf "            \\multicolumn{1} { V{%f in}} { \\textbf{\\seqsplit{%s}}} & \n", colwidth , entry \
    } \
    entry = $i;\
    gsub(/_/,"\\_",entry);\
    printf "            \\multicolumn{1} { V{%f in} } {\\textbf{\\seqsplit{%s}}} \\\\ \\hline\\hline \\endfirsthead\n", 4.0, entry; \
    printf "            \\multicolumn{%d}{c}{Table \\thetable\\ %s (cont.)} \\\\\n", ncols, tablename;\
    print "            % column headers on additional pages";\
    printf "            \\hline\\hline " \
    for( i = 1; i < NF ; i ++) { \
        entry = $i;\
        gsub(/_/,"\\_",entry);\
        printf "            \\multicolumn{1} {V{%f in} } { \\textbf{\\seqsplit{%s}}} & \n", colwidth, entry \
    } \
    entry = $i;\
    gsub(/_/,"\\_",entry);\
    printf "            \\multicolumn{1} { V{%f in} } {\\textbf{\\seqsplit{%s}}} \\\\ \\hline\\hline \\endhead\n", 4.0,  entry; \
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
        if( $i == "element_name" || $i == "external_table" || $i ~ "nhjame" ){\
          printf "            column type= n{%f in}, \n", colwidth;\
        }else{\
          printf "            column type= V{%f in}, \n", colwidth;\
        }\
        print "            string replace*={_}{\\_}";\
        print "        },";\
    }\
    printf "    columns/%s/.style={\n", $i;\
    print "            string type, ";\
    print "            string replace*={_}{\\_},";\
    printf "            column type = V{%f in}\n", 4.0;\
    print "        }";\
    printf "    ]{%s%s}\n", tablepath, file ;\
} \
END { \
    if( ncols > 4){ \
      if( lflag == 1 ){ \
        print "\\end{landscape}";\
      }\
    } \
}\
' > ${tablename}_definition.tex

# Now repeat but for sql syntax



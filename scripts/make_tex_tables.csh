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

set tablepath="/Users/dyb/Documents/Projects/C3S_311a_Lot2/WP2/CDM/github/tables/"

awk -v ncols="$ncols" -v tablename="$tablename" -v file=$file -v tablepath=$tablepath ' \
BEGIN { FS="\t"; \
print "\\begin{table}[h\!]";\
print "  \\begin{center}";\
printf "    \\caption{%s}\n", tablename;\
print "    \\pgfplotstabletypeset[";\
print "        col sep=tab, string type,";\
print "        header=true,";\
print "        every head row/.style={before row=\\toprule\\toprule, after row=\\bottomrule\\bottomrule\\endhead}, ";\
print "        every last row/.style={after row=\\bottomrule},";\
print "        after row=\\hline,";\
};\
/^Value/ || /^ElementNumber/ { \
    printf "        columns={" \
    for( i = 1; i < NF ; i++){ \
        printf "%s,", $i \
    } \
    printf "%s},\n",$i\
    for( i = 1; i < NF ; i++){\
      printf "        columns/%s/.style={string type, column type=l, string replace*={_}{}},\n", $i ;\
    }\
    printf "        columns/%s/.style={string type, column type=p{0.5\\textwidth}, string replace*={_}{}}\n", $i ;\
  };\
END{ \
printf "    ]{%s%s}\n", tablepath, file;\
print "  \\end{center}";\
print "\\end{table}";\
print "";\
};'\
$file

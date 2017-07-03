#!/bin/csh

foreach file (*.csv)
./../scripts/convert2tsv.csh $file
./../scripts/make_tex_tables.csh $file
end

mv *.tsv ./tsv/
mv *.tex ./../tex/

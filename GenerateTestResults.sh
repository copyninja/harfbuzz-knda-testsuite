#!/bin/bash

# invocation : GenerateTestResults.shpath-to-testdata
# 1. generate commands to run hb-view and pango-view with all the words read from input file. each line in input file results in one invocation of hbview
# 2. store them in a test-result subdir
# 3. generate an HTML page which has the following table
#  <word> <generated images> ...


GUBBI_TTF=Gubbi.ttf
NAVILU_TTF=Navilu.ttf
LOHIT_KN=Lohit-Kannada.ttf

rm -fr pango hb index.html

mkdir -p  hb
mkdir -p pango
mkdir -p  hb/Gubbi
mkdir -p  hb/Navilu
mkdir -p  hb/Lohit-Kn
mkdir -p  pango/Gubbi
mkdir -p  pango/Navilu
mkdir -p pango/Lohit-Kn

touch index.html
echo "<html><head><title>Harfbuzz render results</title>" >> index.html
echo "<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>" >> index.html
echo "</head>" >> index.html
echo "<body>" >> index.html
echo "<table border=1 align='center'>" >> index.html
echo "<tr><th>No.</th><th>Word</th><th>Lohit-Kannada (Harfbuzz) </th>" >> index.html
echo "<th>Lohit-Kannada (Pango)</th>" >> index.html
echo "<th>Navilu (Harfbuzz) </th>" >> index.html
echo "<th>Navilu (Pango)</th>" >> index.html
echo "<th>Gubbi (Harfbuzz) </th>" >> index.html
echo "<th>Gubbi (Pango)</th></tr>" >> index.html

# print arguments
#echo "using font file "$2
echo "using test data "$1
number=1
# read characters in inputfile
while read ALINE
do
    echo "processing - "$ALINE
    hb-view $NAVILU_TTF $ALINE --font-size=20 > hb/Navilu/$ALINE.png
    hb-view $LOHIT_KN $ALINE --font-size=20 > hb/Lohit-Kn/$ALINE.png
    hb-view $GUBBI_TTF $ALINE --font-size=20 > hb/Gubbi/$ALINE.png

    pango-view -q --font="Gubbi 20" --text="$ALINE" --output=pango/Gubbi/$ALINE.png
    pango-view -q --font="Lohit-KnMalayalam 20" --text="$ALINE" --output=pango/Lohit-Kn/$ALINE.png
    pango-view -q --font="Navilu 20" --text="$ALINE" --output=pango/Navilu/$ALINE.png
    echo "<tr><td align='center'> $number" >> index.html
    echo "</td><td align='center'>$ALINE" >> index.html
    echo "</td>" >> index.html
    
    echo "<td align='center'><img src='hb/Lohit-Kn/"$ALINE".png'></td>" >> index.html
    echo "<td align='center'><img src='pango/Lohit-Kn/"$ALINE".png'></td>" >> index.html
    echo "<td align='center'><img src='hb/Navilu/"$ALINE".png'></td>" >> index.html
    echo "<td align='center'><img src='pango/Navilu/"$ALINE".png'></td>" >> index.html
    echo "<td align='center'><img src='hb/Gubbi/"$ALINE".png'></td>" >> index.html
    echo "<td align='center'><img src='pango/Gubbi/"$ALINE".png'></td></tr>" >> index.html
    number=$((number + 1))
done < $1

echo "</table></body></html>" >> index.html

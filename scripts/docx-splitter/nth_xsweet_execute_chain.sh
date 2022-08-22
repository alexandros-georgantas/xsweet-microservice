#!/bin/sh

# Directory of script
DIRECTORY=$(cd `dirname $0` && pwd)

# Modified from https://gitlab.coko.foundation/XSweet/XSweet_runner_scripts/raw/master/execute_chain.sh

# For producing HTML5 outputs via XSweet XSLT from sources extracted from .docx (Office Open XML)

# is any short identifier
TEMP=$1
N=$2

XSWEET=$(find ${DIRECTORY}/../.. -maxdepth 1  -name "XSweet*" -print -quit)
# TYPESCRIPT=$(find ${DIRECTORY}/../.. -maxdepth 1  -name 'editoria_typescript*' -print -quit)
# HTMLEVATOR=$(find ${DIRECTORY}/../.. -maxdepth 1  -name 'HTMLevator*' -print -quit)

SAXONDIR=$(find ${DIRECTORY}/../.. -maxdepth 1  -name 'saxon' -print -quit)

echo $XSWEET
# echo $TYPESCRIPT
# echo $HTMLEVATOR

# Note Saxon is included with this distribution, qv for license.
saxonHE="java -jar ${SAXONDIR}/saxon-he-10.3.jar"  # SaxonHE (XSLT 3.0 processor)

# EXTRACTION
PIPELINE="${XSWEET}/applications/PIPELINE.xsl"                       # "Extraction" stylesheet

XMLTOHTML5="${XSWEET}/applications/html-polish/html5-serialize.xsl"


$saxonHE -threads:10 -xsl:$PIPELINE -s:$TEMP/word/document$N.xml -o:$TEMP/outputs/PIPELINED$N.xhtml

if [ $? -eq 0 ]
then
  echo "Made PIPELINED${N}.xhtml"
else
  echo "There was an error converting the document." >&2
  exit 1
fi

$saxonHE -threads:5 -xsl:$XMLTOHTML5 -s:$TEMP/outputs/PIPELINED$N.xhtml -o:$TEMP/outputs/HTML5_$N.html
#Appending everything to HTML5.html
cat "${TEMP}/outputs/HTML5_${N}.html" >> $TEMP/outputs/HTML5.html
#Cleaning merged multi-html for cheerio
sed -i "s/^<\/body><\/html><[^<>]\+><html[^<>]*>/<div id='docx_split${N}' class='docx_split_rule' style='font-size: 30pt; border-bottom: thick solid black;'><b class='scissor'>\&#x2702;<\/b><\/div>/" $TEMP/outputs/HTML5.html
sed -i 's/<title>[^<>]\+<\/title>//g' $TEMP/outputs/HTML5.html
sed -i 's/<meta [^<>]\+>//g' $TEMP/outputs/HTML5.html
sed -i '/^[[:space:]]*$/d' $TEMP/outputs/HTML5.html

if [ $? -eq 0 ]
then
  echo "Made HTML5_${N}.html"
  exit 0
else
  echo "There was an error converting the document." >&2
  exit 1
fi

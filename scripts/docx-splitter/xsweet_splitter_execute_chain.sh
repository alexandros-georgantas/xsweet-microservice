#!/bin/
#A docx splitter preprocessor shell script for XSweet pipeline
#Also a wrapper for default XSweet pipeline for testing purposes


# Directory of script
DIRECTORY=$(cd `dirname $0` && pwd)
SAXONDIR=$(find ${DIRECTORY}/../.. -maxdepth 1  -name 'saxon' -print -quit)
XSWEET=$(find ${DIRECTORY}/../.. -maxdepth 1  -name "XSweet*" -print -quit)
TYPESCRIPT=$(find ${DIRECTORY}/../.. -maxdepth 1  -name 'editoria_typescript*' -print -quit)
# Note Saxon is included with this distribution, qv for license.
saxonHE="java -jar ${SAXONDIR}/saxon-he-10.3.jar"  # SaxonHE (XSLT 3.0 processor)
# A simple bug fix in XSweet
cp $DIRECTORY/docx-html-extract.xsl $XSWEET/applications/docx-extract/

DOCXMLDIR=$1
TOC="${DOCXMLDIR}/word/toc.xml"
DOCXSPLITTER="${TYPESCRIPT}/docx-splitter/"
#DOCXSPLITTER="${XSWEET}/applications/docx-splitter/"
$saxonHE -xsl:$DIRECTORY/split-for-xsweet.xsl -s:$DOCXMLDIR/word/document.xml -o:$TOC
SPLITFILES=$(cat $TOC|grep -oE "<file>[^<>]*document[0-9]+[.]xml<"|sed "s/<file>//"|tr -d "<")

#Empty HTML5 output file
mkdir $DOCXMLDIR/outputs/
echo "" > $DOCXMLDIR/outputs/HTML5.html
N=""
for DOCi in $SPLITFILES; do
    N=$(echo "${DOCi}"|grep -oE "[0-9]+")
    # Calling XSweet Pipeline here:    
    $DIRECTORY/nth_xsweet_execute_chain.sh $DOCXMLDIR $N
done
#If unsplit go to default 
if echo $N|grep -q '^[0-9]';
then
    echo "splitting ..."
else
    $DIRECTORY/../execute_chain.sh "${DOCXMLDIR}"
fi

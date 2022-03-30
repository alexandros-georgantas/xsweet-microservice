#!/bin/bash
#A docx splitter preprocessor shell script for XSweet pipeline
#Also a wrapper for default XSweet pipeline for testing purposes


# Directory of script
DIRECTORY=$(cd `dirname $0` && pwd)
SAXONDIR=$(find ${DIRECTORY}/../.. -maxdepth 1  -name 'saxon' -print -quit)
XSWEET=$(find ${DIRECTORY}/../.. -maxdepth 1  -name "XSweet*" -print -quit)
TYPESCRIPT=$(find ${DIRECTORY}/../.. -maxdepth 1  -name 'editoria_typescript*' -print -quit)
# Note Saxon is included with this distribution, qv for license.
saxonHE="java -jar ${SAXONDIR}/saxon-he-10.3.jar"  # SaxonHE (XSLT 3.0 processor)


DOCXMLDIR=$1
TOC="${DOCXMLDIR}/word/toc.xml"
DOCXSPLITTER="${TYPESCRIPT}/docx-splitter/"
#DOCXSPLITTER="${XSWEET}/applications/docx-splitter/"
$saxonHE -xsl:$DOCXSPLITTER/split-for-xsweet.xsl -s:$DOCXMLDIR/word/document.xml -o:$TOC
SPLITFILES=$(cat $TOC|grep -oP "<file>[^<>]+<"|sed "s/<file>//"|tr -d "<")
for DOCi in $SPLITFILES; do
    N=$(echo "${DOCi}"|grep -oP "[0-9]+")
    # Calling XSweet Pipeline here:    
    ./nth_xsweet_execute_chain.sh ${DOCXMLDIR} ${N}"
done
#If unsplit go to default 
if [[ $SPLITFILES == *"document"* ]]; then
   cd ..
   ./execute_chain.sh
fi

#!/bin/sh

# Directory of this script
DIRECTORY=$(cd `dirname $0` && pwd)


TEMP=$1

SAXONDIR=$(find ${DIRECTORY}/../.. -maxdepth 1  -name 'saxon' -print -quit)


# Note Saxon is included with this distribution, qv for license.
saxonHE="java -jar ${SAXONDIR}/saxon-he-10.3.jar"  # SaxonHE (XSLT 3.0 processor)


# This Ruby script goes through what's in /word/media, and first converts any MathType binary .wmf files to Mathtype XML
# If we're getting somthing in $TEMP/word/media/mtefxml, that's MathType XML. (There might be some other way to convert this?)
# The second step (with Saxon, using the XSL file) converts the MathType to MathML wrapped around TeX. 
# If we get something in $TEMP/word/media/tex, that's MathML wrapped around TeX.

ruby ${DIRECTORY}/mtef2tex.rb $TEMP/word/media/ ${SAXONDIR}/saxon-he-10.3.jar ${DIRECTORY}/mtef2tex.xsl

if [ $? -eq 0 ]
then
	# more $TEMP/word/media/mtefxml/image1
  echo "Generated TeX files from MathType equations!"
	# ls -R $TEMP/word/media/tex
  exit 0
else
  echo "There was an error converting WMF files." >&2
  exit 1
fi

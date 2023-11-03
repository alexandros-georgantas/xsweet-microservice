#!/bin/sh

# Directory of script
DIRECTORY=$(cd `dirname $0` && pwd)

# Modified from execute_chain.sh

# For producing HTML5 outputs via Pandoc from sources extracted from .docx (Office Open XML)

# is any short identifier
TEMP=$1

pandoc -s :$TEMP/document.docx -o:$TEMP/HTML5.html --embed-resources --shift-heading-level-by=1 -C

if [ $? -eq 0 ]
then
  echo "Made HTML5.html"
  exit 0
else
  echo "There was an error converting the document." >&2
  exit 1
fi
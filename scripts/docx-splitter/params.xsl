<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
  version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:param name="number-full" select="'(one|two|three|four(teen)?|five|six(teen)|seven(teen)|eight(een)|nine(teen)|ten|eleven|twelve|thirteen|fifteen|twenty)'" />
  <xsl:param name="chap-number" select="concat('^[\s\t]*(&lt;[A-Za-z-]+&gt;)?[\s\t]*Chapter[\s\t]*([0-9]+|[IVX]+|', $number-full, ')[\s\t]*($|:)')"/>
  <xsl:param name="chap" select="'^[\s\t]*(&lt;[A-Za-z-]+&gt;)?[\s\t]*(Chapter|Appendix)[\s\t]*$'"/>
  <xsl:param name="number" select="concat('^[\s\t]*(&lt;[A-Za-z-]+&gt;)?[\s\t]*([0-9]+|[IVX]+|', $number-full, ')[\s\t]*$')"/>
  <xsl:param name="chap-title-class-name" select="'((chapter|appendix)[-]?title|chapter[-]?label)'"/>
  <xsl:param name="chap-number-class-name" select="'((chapter|appendix)[-]?(no|number))'"/>
</xsl:stylesheet>

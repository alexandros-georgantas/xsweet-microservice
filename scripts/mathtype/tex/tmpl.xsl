<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:math="http://www.w3.org/2005/xpath-functions/math" xmlns:f="func" exclude-result-prefixes="xs" version="3.0">

  <xsl:template match="tmpl[selector='tmFRACT']" priority="10">
    <xsl:text>\frac{</xsl:text>
    <xsl:apply-templates select="slot[descendant::char][1]" />
    <xsl:text>}{</xsl:text>
    <xsl:apply-templates select="slot[descendant::char][2]" />
    <xsl:text>}</xsl:text>
  </xsl:template>
  
  <xsl:template match="tmpl[selector='tmINTEG' or selector='tmSUBSUP' or selector='tmSUM']" priority="10">
    <xsl:apply-templates select="*[preceding-sibling::*[1][self::sym]]" />
    <xsl:text>_{</xsl:text>
    <xsl:apply-templates select="sub/following-sibling::*[1]" />
    <xsl:text>}^{</xsl:text>
    <xsl:apply-templates select="sub/following-sibling::*[2]" />
    <xsl:text>}</xsl:text>
    <xsl:apply-templates select="sub/preceding-sibling::*" />
  </xsl:template>
  
  <xsl:template match="tmpl[selector='tmSUB']" priority="10">
    <xsl:text>_{</xsl:text>
    <xsl:apply-templates select="slot[descendant::char]" />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="tmpl[selector='tmSUP']" priority="10">
    <xsl:text>^{</xsl:text>
    <xsl:apply-templates select="slot[descendant::char]" />
    <xsl:text>}</xsl:text>
  </xsl:template>

   <xsl:template match="tmpl[selector='tmBOX']" priority="10">
    <xsl:text>\fbox{</xsl:text>
    <xsl:apply-templates select="slot[descendant::char]" />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="tmpl[matches(selector,'tm(PAREN|BRACK|BRACE|BAR|ANGLE)')]" priority="10">
    <xsl:choose>
      <xsl:when test="variation='tvFENCE_L'">
	<xsl:text>\left</xsl:text>
	<xsl:if test="char[1]/mt_code_value='0x007B'">
	  <xsl:text>\</xsl:text>
	</xsl:if>
	<xsl:apply-templates select="char[1]" />
      </xsl:when>
      <xsl:otherwise>
	<xsl:text>\left.</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="slot[descendant::char]" />
    <xsl:choose>
      <xsl:when test="variation='tvFENCE_L' and variation='tvFENCE_R'">
	<xsl:text>\right</xsl:text>
	<xsl:if test="char[2]/mt_code_value='0x007D'">
	  <xsl:text>\</xsl:text>
	</xsl:if>
	<xsl:apply-templates select="char[2]" />
      </xsl:when>
      <xsl:when test="not(variation='tvFENCE_L') and variation='tvFENCE_R'">
	<xsl:text>\right</xsl:text>
	<xsl:if test="char[1]/mt_code_value='0x007D'">
	  <xsl:text>\</xsl:text>
	</xsl:if>
	<xsl:apply-templates select="char[1]" />
      </xsl:when>
      <xsl:otherwise>
	<xsl:text>\right.</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="matrix" priority="10">
    <xsl:param name="cols" select="cols" />
    <xsl:param name="rows" select="rows" />
    <xsl:text>&#10;\begin{matrix}&#10;</xsl:text>
    <xsl:for-each select="pile|slot">
      <xsl:apply-templates select="*" />
      <xsl:if test="not(position() = (($rows)*($cols)))">
	<xsl:choose>
	  <xsl:when test="(position() mod ($cols)) = 0">
	    <xsl:text disable-output-escaping="true"> \\ &#10; </xsl:text>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:text disable-output-escaping="true"> &amp; </xsl:text>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:if>
    </xsl:for-each>
    <xsl:text>&#10;\end{matrix}&#10;</xsl:text>
  </xsl:template>

</xsl:stylesheet>

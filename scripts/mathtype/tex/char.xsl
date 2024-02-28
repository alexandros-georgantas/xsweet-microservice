<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:math="http://www.w3.org/2005/xpath-functions/math" xmlns:f="func" exclude-result-prefixes="xs" version="3.0">
  
  <xsl:template name="charhex">
    <xsl:param name="mt_code_value"/>
    <xsl:choose>
      <xsl:when test="$mt_code_value=$map-private-to-unicode/charmap/@private-hex">
	<xsl:apply-templates select="$map-private-to-unicode/charmap/@unicode-hex"/>	
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="codepoints-to-string(f:hex-to-dec($mt_code_value))"/>
      </xsl:otherwise>
    </xsl:choose>      
  </xsl:template>

  <!-- Default char translation for mathmode -->
  <xsl:template match="char">
    <xsl:call-template name="charhex">
      <xsl:with-param name="mt_code_value" select="substring(mt_code_value/text(),3)" />
    </xsl:call-template>
  </xsl:template>

  <!-- Default char translation for textmode -->
  <xsl:template match="char[variation = 'textmode']">
    <xsl:text>\text{</xsl:text>
    <xsl:call-template name="charhex">
      <xsl:with-param name="mt_code_value" select="mt_code_value/text()" />
    </xsl:call-template>
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:function name="f:hex-to-dec">
    <xsl:param name="hex"/>
    <xsl:variable name="hexvals" select="'0123456789ABCDEF'"/>
    <xsl:choose>
      <xsl:when test="$hex=''">0</xsl:when>
      <xsl:otherwise>
        <xsl:value-of
            select="string-length(substring-before($hexvals,substring(upper-case($hex),1,1)))
                    * math:pow(16,string-length($hex)-1) + f:hex-to-dec(substring($hex,2))"
            />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
</xsl:stylesheet>

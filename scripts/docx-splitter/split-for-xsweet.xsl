<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
    version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsw="http://coko.foundation/xsweet"
    xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
    xmlns:rel="http://schemas.openxmlformats.org/package/2006/relationships"
    xmlns:v="urn:schemas-microsoft-com:vml"
    xmlns:o="urn:schemas-microsoft-com:office:office"
    xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
    xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
    xmlns:math="http://www.w3.org/1998/Math/MathML"
    xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math">
  <!-- Indent should really be no, but for testing. -->
  <xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
  <!-- XSweet: splits document.xml into multiple chapter xml files -->
  <!-- Input: document.xml -->
  <!-- Output: multiple chapter xml files -->
  <xsl:template match="node()|*|@*|comment()|processing-instruction()">
    <xsl:copy>
      <xsl:apply-templates select="node()|*|@*|comment()|processing-instruction()"/>
    </xsl:copy>
  </xsl:template>
  
  <!--Regular expression parameters -->
  <xsl:include href="params.xsl" />
  <!--TOC xml output-->
  <xsl:template match="/w:document">
    <docs>
      <xsl:apply-templates />
    </docs>
  </xsl:template>

  <!-- Splitting w:body content into multiple document*.xml based on Chapter Number patterns -->
  <xsl:template name="chap">
    <xsl:param name="nodes" />
    <xsl:for-each-group select="w:p|w:tbl" group-starting-with="$nodes">
      <xsl:variable name="xml-doc-filename"><xsl:text>document</xsl:text><xsl:value-of select="position()" /><xsl:text>.xml</xsl:text></xsl:variable>
      <xsl:variable name="xml-fn-filename"><xsl:text>footnotes</xsl:text><xsl:value-of select="position()" /><xsl:text>.xml</xsl:text></xsl:variable>
      <xsl:variable name="xml-en-filename"><xsl:text>endnotes</xsl:text><xsl:value-of select="position()" /><xsl:text>.xml</xsl:text></xsl:variable>
      <xsl:variable name="group" select="current-group()" />
      <file><xsl:value-of select="$xml-doc-filename" /></file>
      <xsl:result-document href="{$xml-doc-filename}">
	<w:document>
	  <w:body>
	    <xsl:apply-templates select="$group" />
	  </w:body>
	</w:document>
      </xsl:result-document>
      <xsl:result-document href="{$xml-fn-filename}">
	<w:footnotes>
	  <xsl:for-each select="$group//w:r/w:footnoteReference/@w:id">
	    <xsl:variable name="footnotes-id" select="."/>
	    <xsl:variable name="footnotes-file" select="resolve-uri('footnotes.xml', document-uri(/))"/>
	    <xsl:variable name="footnotes-doc" select="doc($footnotes-file)"/>
	    <xsl:variable name="fn" select="$footnotes-doc//w:footnote[@w:id=$footnotes-id]" />
	    <xsl:variable name="fno" select="position()" />
	    <xsl:apply-templates select="$fn"/>
	  </xsl:for-each>
	</w:footnotes>
      </xsl:result-document>
      <xsl:result-document href="{$xml-en-filename}">
	<w:endnotes>
	  <xsl:for-each select="$group//w:r/w:endnoteReference/@w:id">
	    <xsl:variable name="endnotes-id" select="."/>
	    <xsl:variable name="endnotes-file" select="resolve-uri('endnotes.xml', document-uri(/))"/>
	    <xsl:variable name="endnotes-doc" select="doc($endnotes-file)"/>
	    <xsl:variable name="en" select="$endnotes-doc//w:endnote[@w:id=$endnotes-id]" />
	    <xsl:apply-templates select="$en"/>
	  </xsl:for-each>
	</w:endnotes>
      </xsl:result-document>
    </xsl:for-each-group>
  </xsl:template>
  <!-- Splitting w:body content into multiple document.xml based on Chapter Number patterns -->
  <xsl:template match="w:body">
    <xsl:param name="nodes-pagebreak-number" select="w:p[(matches(w:r[1]/w:t[1],$number, 'i') or matches(.,$number, 'i'))
                                                         and preceding-sibling::*[1]/w:r/w:br[@w:type='page']]" />
    <xsl:param name="nodes-chap-number" select="w:p[matches(w:r[1]/w:t[1],$chap-number, 'i') or matches(.,$chap-number, 'i')]" />
    <xsl:param name="nodes-chap" select="w:p[(matches(w:r[1]/w:t[1],$chap, 'i') 
                                         and (matches(following-sibling::w:p[1]/w:r[1]/w:t[1],$number) 
                                         or matches(w:r[2]/w:t[1],$number)))
                                         or (matches(.,$chap, 'i') and matches(./following-sibling::w:p[1],$number))
                                         or (matches(.,$chap, 'i') and matches(./following-sibling::w:p[1]/w:r[1]/w:t[1],$number)
                                         and ./following-sibling::w:p[1]/w:r[1]/w:*[2][self::w:br])]" /> 
    <xsl:param name="nodes-chap-title-class-name" select="w:p[matches(w:pPr/w:pStyle/@w:val,$chap-title-class-name,'i')]" />
    <xsl:param name="nodes-chap-number-class-name" select="w:p[matches(w:pPr/w:pStyle/@w:val,$chap-number-class-name,'i')]" />
    <xsl:choose>
      <xsl:when test="count($nodes-pagebreak-number) &gt; 2">
	<debug>nodes-pagebreak-number</debug>
	<xsl:call-template name="chap">
	  <xsl:with-param name="nodes" select="$nodes-pagebreak-number" />
	</xsl:call-template>
      </xsl:when>
      <xsl:when test="count($nodes-chap-number) &gt; 2">
	<debug>nodes-chap-number</debug>
	<xsl:call-template name="chap">
	  <xsl:with-param name="nodes" select="$nodes-chap-number" />
	</xsl:call-template>
      </xsl:when>
      <xsl:when test="count($nodes-chap) &gt; 2">
	<debug>nodes-chap</debug>
	<xsl:call-template name="chap">
	  <xsl:with-param name="nodes" select="$nodes-chap" />
	</xsl:call-template>
      </xsl:when>
      <xsl:when test="count($nodes-chap-title-class-name) &gt; 2">
	<debug>nodes-chap-title-class-name</debug>
	<xsl:call-template name="chap">
	  <xsl:with-param name="nodes" select="$nodes-chap-title-class-name" />
	</xsl:call-template>
      </xsl:when>
      <xsl:when test="count($nodes-chap-number-class-name) &gt; 2">
	<debug>nodes-chap-number-class-name</debug>
	<xsl:call-template name="chap">
	  <xsl:with-param name="nodes" select="$nodes-chap-number-class-name" />
	</xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>

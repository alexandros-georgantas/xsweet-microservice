<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
  version="3.0"
  xmlns="http://www.w3.org/1999/xhtml"
  xpath-default-namespace="http://www.w3.org/1999/xhtml"
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
  xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math"
  exclude-result-prefixes="#all">

  <!-- Indent should really be no, but for testing. -->
  <xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
  <!-- XSweet: splits document.xml into multiple chapter xml files -->
  <!-- Input: document.xml -->
  <!-- Output: multiple chapter html files -->
  <!--Regular expression parameters -->
  <xsl:include href="params.xsl" />

  <xsl:template match="node()|comment()|processing-instruction()">
    <xsl:copy>
      <xsl:apply-templates select="node()|*|@*|comment()|processing-instruction()"/>
    </xsl:copy>
  </xsl:template>


  <!-- Splitting w:body content into multiple document*.html based on Chapter Number patterns -->
  <xsl:template name="chap">
    <xsl:param name="nodes" />
    <xsl:for-each-group select="div/*[../@class='docx-body']" group-starting-with="$nodes">
      <xsl:variable name="p" select="position()" />
      <xsl:variable name="g" select="current-group()" />
      <xsl:variable name="html-filename"><xsl:text>document</xsl:text><xsl:value-of select="$p" /><xsl:text>.html</xsl:text></xsl:variable>
      <div class="split-docxml"><a href="{$html-filename}"><xsl:value-of select="$html-filename" /></a></div>
      <xsl:result-document href="{$html-filename}">
	<html>
	  <head>
	    <title><xsl:text>Chapter</xsl:text><xsl:value-of select="$p" /><xsl:text> document</xsl:text></title>
	  </head>
	  <body>
	    <div class='docx-body'>
	      <xsl:apply-templates select="current-group()" />
	    </div>
	    <div class='docx-footnotes'>
	      <xsl:for-each select="//div[@class='docx-footnote']">
		<xsl:variable name="id" select="@id" />
		<xsl:variable name="idr" select="concat('#',$id)" />
		<xsl:choose>
		  <xsl:when test="$g//*[@href=$idr]">
		    <xsl:copy>
		      <xsl:apply-templates />
		    </xsl:copy>
		  </xsl:when>
		  <xsl:otherwise/>
		</xsl:choose>
	      </xsl:for-each>
	    </div>
	    <div class='docx-endnotes'>
	      <xsl:for-each select="//div[@class='docx-endnote']">
		<xsl:variable name="id" select="@id" />
		<xsl:variable name="idr" select="concat('#',$id)" />
		    <xsl:choose>
		      <xsl:when test="$g//*[@href=$idr]">
			<xsl:copy>
			  <xsl:apply-templates />
			</xsl:copy>
		      </xsl:when>
		      <xsl:otherwise/>
		    </xsl:choose>
	      </xsl:for-each>
	    </div>
	  </body>
	</html>
      </xsl:result-document>
    </xsl:for-each-group>
  </xsl:template>
  <!-- Splitting w:body content into multiple document.html based on Chapter Number patterns -->
  <xsl:template match="body">
    <xsl:param name="nodes-pagebreak-number" select="div[@class='docx-body']/*[matches(.,$number, 'i') and preceding-sibling::br[1][@class='page']]" />
    <xsl:param name="nodes-chap-number" select="div[@class='docx-body']/*[matches(.,$chap-number, 'i')]" />
    <xsl:param name="nodes-chap" select="div[@class='docx-body']/*[matches(.,$chap, 'i') and matches(following-sibling::*[1]/node()[1],$number)]"/> 
    <xsl:param name="nodes-chap-title-class-name" select="div[@class='docx-body']/*[matches(@class,$chap-title-class-name,'i')]" />
    <xsl:param name="nodes-chap-number-class-name" select="div[@class='docx-body']/*[matches(@class,$chap-number-class-name,'i')]" />
    <body>
      <xsl:choose>
	<xsl:when test="count($nodes-pagebreak-number) &gt; 2">
	  <div class="debug">nodes-pagebreak-number</div>
	  <xsl:call-template name="chap">
	    <xsl:with-param name="nodes" select="$nodes-pagebreak-number" />
	  </xsl:call-template>
	</xsl:when>
	<xsl:when test="count($nodes-chap-number) &gt; 2">
	  <div class="debug">nodes-chap-number</div>
	  <xsl:call-template name="chap">
	    <xsl:with-param name="nodes" select="$nodes-chap-number" />
	  </xsl:call-template>
	</xsl:when>
	<xsl:when test="count($nodes-chap) &gt; 2">
	  <div class="debug">nodes-chap</div>
	  <xsl:call-template name="chap">
	    <xsl:with-param name="nodes" select="$nodes-chap" />
	  </xsl:call-template>
	</xsl:when>
	<xsl:when test="count($nodes-chap-title-class-name) &gt; 2">
	  <div class="debug">nodes-chap-title-class-name</div>
	  <xsl:call-template name="chap">
	    <xsl:with-param name="nodes" select="$nodes-chap-title-class-name" />
	  </xsl:call-template>
	</xsl:when>
	<xsl:when test="count($nodes-chap-number-class-name) &gt; 2">
	  <div class="debug">nodes-chap-number-class-name</div>
	  <xsl:call-template name="chap">
	    <xsl:with-param name="nodes" select="$nodes-chap-number-class-name" />
	  </xsl:call-template>
	</xsl:when>
      </xsl:choose>
    </body>
  </xsl:template>
</xsl:stylesheet>

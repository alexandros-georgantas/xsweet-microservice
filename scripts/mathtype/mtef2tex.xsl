<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:v="urn:schemas-microsoft-com:vml" exclude-result-prefixes="xs" version="3.0">

  <xsl:output method="xml" indent="no" encoding="UTF-8" />

  <xsl:template match="/ |node() | @*">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*"/>
    </xsl:copy>
  </xsl:template>

  <xsl:strip-space elements="*" />

  <xsl:template match="root">
    <math>
      <xsl:apply-templates/>
    </math>
  </xsl:template>
  
  <xsl:template match="mtef/descendant::*[descendant::char]">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="eqn_prefs|font_def|encoding_def|mtef_version|platform|product|product_version|product_subversion|application_key|equation_option|options|selector|end|full|template_specific_options|variation" />

  <xsl:template match="*[ancestor::mtef and count(node()) = 0]" />
  <xsl:template match="slot[options and count(*) = 1]" />

  <xsl:template match="mtef">
    <tex display="inline">
      <xsl:apply-templates select="pile | slot"/>
    </tex>
  </xsl:template>

  <xsl:template match="mtef[equation_options = 'block']">
    <tex display="block">
      <xsl:apply-templates select="pile | slot"/>
    </tex>
  </xsl:template>

  <xsl:include href="tex/char.xsl" />
  <xsl:include href="tex/tmpl.xsl" />
  <xsl:include href="params/private-chars.xsl" />
  
</xsl:stylesheet>

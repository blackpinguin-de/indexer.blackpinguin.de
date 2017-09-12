<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:str="http://exslt.org/strings"
	extension-element-prefixes="str"
>



<xsl:import href="EXSLT/str/functions/replace/str.replace.template.xsl" />



<xsl:output method="xml"
	encoding="UTF-8"
	omit-xml-declaration="no"
	indent="no"
/>



<xsl:template match="/">
	<indexer>
		<xsl:attribute name="gendate">
			<xsl:call-template name="dateformat"><xsl:with-param name="date" select="/indexer[1]/@gendate"/></xsl:call-template>
		</xsl:attribute>
		<xsl:for-each select="/indexer[1]/index[1]/layer">
			<xsl:call-template name="layer" />
		</xsl:for-each>
	</indexer>
</xsl:template>



<!-- Rekursive Funktion: Ausgabe einer Ebene -->
<xsl:template name="layer">
	<layer>
		<!-- kopiere die öffentlichen attribute -->
		<xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
		<xsl:attribute name="dirName"><xsl:value-of select="@url"/></xsl:attribute>
		<xsl:if test="@duration"><xsl:attribute name="duration"><xsl:value-of select="@duration"/></xsl:attribute></xsl:if>
		<xsl:if test="@comments"><xsl:attribute name="comments"><xsl:value-of select="@comments"/></xsl:attribute></xsl:if>
		<xsl:if test="@videos"><xsl:attribute name="videoCount"><xsl:value-of select="@videos"/></xsl:attribute></xsl:if>
		
		<!-- Rekursiver Aufruf für Sublayer -->
		<xsl:for-each select="layer">
			<xsl:call-template name="layer" />
		</xsl:for-each>
		
		<!-- löse die vref referenz auf, und kopiere das referenzierte Video 1:1 -->
		<xsl:for-each select="vref">
			<xsl:variable name="id" select="@id" />
			<xsl:copy-of select="/indexer[1]/videos[1]/video[@id=$id]"/>
		</xsl:for-each>
		
	</layer>
</xsl:template>



<xsl:template name="dateformat">
	<xsl:param name="date" />
	<xsl:call-template name="str:replace">
		<xsl:with-param name="string" select="$date" />
		<xsl:with-param name="search" select="' '" />
		<xsl:with-param name="replace" select="'T'" />
	</xsl:call-template>
</xsl:template>



</xsl:stylesheet>
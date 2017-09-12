<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:str="http://exslt.org/strings"
	extension-element-prefixes="str"
>



<xsl:import href="EXSLT/str/functions/replace/str.replace.template.xsl" />



<xsl:output method="text"
	media-type="application/json"
	encoding="UTF-8"
	omit-xml-declaration="yes"
	indent="no"
/>



<xsl:template match="/">
	<xsl:text>{</xsl:text>
		<xsl:text>"gendate":"</xsl:text>
		<xsl:call-template name="dateformat"><xsl:with-param name="date" select="/indexer[1]/@gendate"/></xsl:call-template><xsl:text>",</xsl:text>
		<xsl:text>"layers":[</xsl:text>
		<xsl:for-each select="/indexer[1]/index[1]/layer">
			<xsl:call-template name="layer" />
			<!-- Komma, außer beim letzten -->
			<xsl:if test="position() != last()">,</xsl:if>
		</xsl:for-each>
		<xsl:text>]</xsl:text>
	<xsl:text>}</xsl:text>
</xsl:template>



<!-- Rekursive Funktion: Ausgabe einer Ebene -->
<xsl:template name="layer">
	<xsl:text>{</xsl:text>
		<!-- kopiere die öffentlichen attribute -->
		<xsl:text>"name":"</xsl:text><xsl:value-of select="@name"/><xsl:text>",</xsl:text>
		<xsl:text>"dirName":"</xsl:text><xsl:value-of select="@url"/><xsl:text>",</xsl:text>
		<xsl:if test="@duration"><xsl:text>"duration":"</xsl:text><xsl:value-of select="@duration"/><xsl:text>",</xsl:text></xsl:if>
		<xsl:if test="@comments"><xsl:text>"comments":</xsl:text><xsl:value-of select="@comments"/><xsl:text>,</xsl:text></xsl:if>
		<xsl:if test="@videos"><xsl:text>"videoCount":</xsl:text><xsl:value-of select="@videos"/><xsl:text>,</xsl:text></xsl:if>
		
		<!-- für alle Sublayer -->
		<xsl:text>"layers":[</xsl:text>
		<xsl:for-each select="layer">
			<!-- Rekursiver Aufruf -->
			<xsl:call-template name="layer" />
			<!-- Komma, außer beim letzten -->
			<xsl:if test="position() != last()">,</xsl:if>
		</xsl:for-each>
		<xsl:text>],</xsl:text>
		
		<!-- löse die vref referenz auf, und kopiere das referenzierte Video 1:1 -->
		<xsl:text>"videos":[</xsl:text>
		<xsl:for-each select="vref">
			<xsl:variable name="id" select="@id" />
			<!-- Video auswählen -->
			<xsl:for-each select="/indexer[1]/videos[1]/video[@id=$id]">
				<xsl:call-template name="video" />
			</xsl:for-each>
			<!-- Komma, außer beim letzten -->
			<xsl:if test="position() != last()">,</xsl:if>
		</xsl:for-each>
		<xsl:text>]</xsl:text>
	<xsl:text>}</xsl:text>
</xsl:template>



<xsl:template name="video">
	<xsl:text>{</xsl:text>
		<xsl:text>"id":</xsl:text><xsl:value-of select="@id"/><xsl:text>,</xsl:text>
		<xsl:text>"date":"</xsl:text><xsl:value-of select="@date"/><xsl:text>",</xsl:text>
		<xsl:text>"pubdate":"</xsl:text><xsl:value-of select="@pubdate"/><xsl:text>",</xsl:text>
		<xsl:if test="@duration"><xsl:text>"duration":"</xsl:text><xsl:value-of select="@duration"/><xsl:text>",</xsl:text></xsl:if>
		<xsl:text>"author":"</xsl:text><xsl:value-of select="@author"/><xsl:text>",</xsl:text>
		<xsl:text>"title":"</xsl:text><xsl:value-of select="@title"/><xsl:text>",</xsl:text>
		<xsl:text>"url":"</xsl:text><xsl:value-of select="@url"/><xsl:text>",</xsl:text>
		<xsl:if test="@comments"><xsl:text>"comments":</xsl:text><xsl:value-of select="@comments"/><xsl:text>,</xsl:text></xsl:if>
		<xsl:text>"files":[</xsl:text>
			<xsl:for-each select="file">
				<xsl:text>{</xsl:text>
					<xsl:text>"type":"video/</xsl:text><xsl:value-of select="@type"/><xsl:text>",</xsl:text>
					<xsl:text>"url":"</xsl:text><xsl:value-of select="@url"/><xsl:text>"</xsl:text>
				<xsl:text>}</xsl:text>
				<!-- Komma, außer beim letzten -->
				<xsl:if test="position() != last()">,</xsl:if>
			</xsl:for-each>
		<xsl:text>]</xsl:text>
	<xsl:text>}</xsl:text>
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
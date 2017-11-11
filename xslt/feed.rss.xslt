<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:date="http://exslt.org/dates-and-times"
	extension-element-prefixes="date">
>

<xsl:output method="xml" encoding="UTF-8" />

<xsl:import href="EXSLT/date/functions/format-date/date.format-date.template.xsl" />

<xsl:strip-space elements="*"/>

<xsl:variable name="maxFeedVideos" select="number(50)" />
<xsl:variable name="lastid" select="number(/indexer[1]/videos[1]/@latest)" />

<xsl:variable name="relPath" select="/indexer[1]/index[1]/layer[1]/@relPath" />
<xsl:variable name="docTitle">
	<xsl:choose>
		<xsl:when test="not($relPath) or $relPath = ''">Alle Videos</xsl:when>
		<xsl:otherwise>
			<xsl:for-each select="/indexer[1]/index[1]/parent">
				<xsl:value-of select="@name"/>
				<xsl:text> / </xsl:text>
			</xsl:for-each>
			<xsl:value-of select="/indexer[1]/index[1]/layer[1]/@name"></xsl:value-of>
		</xsl:otherwise>
	</xsl:choose>
</xsl:variable>


<xsl:template match="/">
<rss version="2.0" xmlns:dc="http://purl.org/dc/elements/1.1/">
	<channel>
		<title><xsl:value-of select="$docTitle"/></title>
		<link>http://weitz.de/haw-videos/</link>
		<description>Ein Index von Video Links der Mediathek der Fakultät DMI der HAW Hamburg</description>
		<language>de-DE</language>
		<generator>XSLT</generator>
		
		
		<lastBuildDate>
			<xsl:call-template name="rssdate">
				<xsl:with-param name="date" select="concat(substring-before(/indexer[1]/@gendate, ' '),'T', substring-after(/indexer[1]/@gendate, ' '))"/>
			</xsl:call-template>
		</lastBuildDate>
		
		<xsl:for-each select="/indexer[1]/index[1]/layer">
			<xsl:call-template name="layer" />
		</xsl:for-each>
		
		<xsl:text>&#xa;</xsl:text>
	</channel>
</rss>
</xsl:template>






<!-- Rekursive Funktion: Ausgabe einer Ebene -->
<xsl:template name="layer">
	<!-- Funktionsparameter mit Default-Wert -->
	<xsl:param name="path" select="@name" />

	<!-- Funktionskörper -->
	
	<!-- für alle layer Unterelemente -->
	<xsl:for-each select="layer">
		<!-- Rekursionsaufruf mit Parameter -->
		<xsl:call-template name="layer">
			<xsl:with-param name="path" select="concat($path, ' / ', @name)"/>
		</xsl:call-template>
	</xsl:for-each>
		
	<!-- für alle vref Unterelemente -->
	<xsl:for-each select="vref">
		<!-- Funktionsaufruf mit Parameter -->
		<xsl:call-template name="vref">
			<xsl:with-param name="title" select="concat($path, ' / ', @title)"/>
		</xsl:call-template>
	</xsl:for-each>
	
</xsl:template>



<!-- Funktion: Finden und Ausgeben eines Videos anhand der ID -->
<xsl:template name="vref">
	<!-- Funktionsparameter -->
	<xsl:param name="title" />
	
	<xsl:variable name="id" select="number(@id)" />
	
	<xsl:if test="($lastid - $id) &lt; $maxFeedVideos">
		<xsl:for-each select="/indexer[1]/videos[1]/video[@id = $id]">
			<xsl:variable name="url" select="@url" />
			<xsl:text>&#xa;</xsl:text>
			<item>
				<title><xsl:value-of select="$title"/></title>
				<link><xsl:value-of select="$url"/></link>
				<dc:creator><xsl:value-of select="@author"/></dc:creator>
				<xsl:if test="@comments">
				<comments><xsl:value-of select="$url"/>#media_comments_list</comments>
				</xsl:if>
				<description>
					<xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
					
					<a target="_blank" rel="noopener">
						<xsl:attribute name="href"><xsl:value-of select="$url"/></xsl:attribute>
						<xsl:value-of select="$title"/>
					</a>
					
					<br/>
					<video width="400" height="300" preload="none" controls="controls">
						<xsl:for-each select="file">
							<source>
								<xsl:attribute name="src"><xsl:value-of select="@url"/></xsl:attribute>
								<xsl:attribute name="type">video/<xsl:value-of select="@type"/></xsl:attribute>
							</source>
						</xsl:for-each>
					</video>
										
					<br/>Autor: <a target="_blank" rel="noopener">
						<xsl:attribute name="href">http://mediathek.mt.haw-hamburg.de/user/view/user/<xsl:value-of select="@author"/></xsl:attribute>
						<xsl:value-of select="@author"/>
					</a>
				
					<br/>Datum: <xsl:value-of select="@date"/>
				
					<xsl:if test="@duration">
						<br/>Dauer: <xsl:value-of select="@duration"/>
					</xsl:if>
				
					<br/>Dateien:<xsl:for-each select="file">
						<xsl:text> </xsl:text><a target="_blank" rel="noopener">
							<xsl:attribute name="href"><xsl:value-of select="@url"/></xsl:attribute>
							<xsl:value-of select="@type"/>
						</a>
					</xsl:for-each>
					
					<xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
				</description>
				<pubDate>
					<xsl:call-template name="rssdate">
						<xsl:with-param name="date" select="@pubdate"/>
					</xsl:call-template>
				</pubDate>
			</item>
		</xsl:for-each>
	</xsl:if>
</xsl:template>





<!-- Funktion: YYYY-MM-DD zu RSS-Datumsformat -->
<xsl:template name="rssdate">
	<!-- Funktionsparameter -->
	<xsl:param name="date" />
		
	<!-- Funktionskörper -->
	<xsl:call-template name="date:format-date">
		<xsl:with-param name="date-time" select="$date" />
		<xsl:with-param name="pattern" select="'EEE, dd MMM yyyy HH:mm:ss'" />
	</xsl:call-template>
	<xsl:text> +0100</xsl:text>
</xsl:template>



</xsl:stylesheet>

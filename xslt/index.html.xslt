<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:str="http://exslt.org/strings"
	extension-element-prefixes="str"
>


<xsl:import href="EXSLT/str/functions/replace/str.replace.template.xsl" />


<xsl:output method="html"
	encoding="UTF-8"
	doctype-system="about:legacy-compat"
	omit-xml-declaration="yes"
	standalone="yes"
	indent="no"
/>



<xsl:variable name="relPath" select="/indexer[1]/index[1]/layer[1]/@relPath" />
<xsl:variable name="docTitle"><xsl:if test="not($relPath) or $relPath = ''">Alle Videos</xsl:if><xsl:if test="$relPath"><xsl:value-of select="/indexer[1]/index[1]/layer[1]/@name" /></xsl:if></xsl:variable>


<xsl:strip-space elements="*"/>



<xsl:template match="/">
<html lang="de">
<head>
	<title>
		<xsl:value-of select="$docTitle" /> - Videoindex
	</title>
	<script type="text/javascript" >
		<xsl:attribute name="src"><xsl:value-of select="$relPath"/>jquery-1.10.2.min.js</xsl:attribute>
	</script>      
	<script type="text/javascript">
		<xsl:attribute name="src"><xsl:value-of select="$relPath"/>script.js</xsl:attribute>
	</script>
	<link rel="stylesheet" type="text/css">
		<xsl:attribute name="href"><xsl:value-of select="$relPath"/>style.css</xsl:attribute>
	</link>
	<link rel="alternate" type="application/rss+xml" href="feed.rss">
		<xsl:attribute name="title"><xsl:value-of select="$docTitle"/> als Feed abonnieren (RSS)</xsl:attribute>
	</link>
</head>
<body>
	<header>
		<span>
			<xsl:if test="$relPath">
				<a>
					<xsl:attribute name="href"><xsl:value-of select="$relPath" /></xsl:attribute>
					<xsl:attribute name="title">Alle Videos</xsl:attribute>Alle Videos</a>
				<xsl:text> / </xsl:text>
				<xsl:for-each select="/indexer[1]/index[1]/parent">
					<a>
						<xsl:attribute name="href"><xsl:value-of select="@path" /></xsl:attribute>
						<xsl:attribute name="title"><xsl:value-of select="@name" /></xsl:attribute>
						<xsl:value-of select="@name" />
					</a>
					<xsl:text> / </xsl:text>
				</xsl:for-each>
			</xsl:if>
			<xsl:value-of select="$docTitle" />
		</span>
		<a class="rss" href="feed.rss">
			<xsl:attribute name="title"><xsl:value-of select="$docTitle"/> als Feed abonnieren (RSS)</xsl:attribute>
		</a>
		<a class="json" href="data.json" title="JSON-Daten"></a>
		<a class="xml" href="data.xml" title="XML-Daten"></a>
	</header>
	
	<div id="background">
		<div id="videocont" class="round"></div>
	</div>
	
	<xsl:if test="not($relPath) or $relPath = ''">
		<xsl:for-each select="/indexer[1]/index[1]/layer">
			<xsl:call-template name="layer" />
		</xsl:for-each>
	</xsl:if>
	
	<xsl:if test="$relPath">
		<xsl:for-each select="/indexer[1]/index[1]/layer">
			<xsl:call-template name="layerDiv">
				<xsl:with-param name="path">
					<xsl:value-of select="/indexer[1]/index[1]/layer[1]/@absPath"/>
				</xsl:with-param>
				<xsl:with-param name="accuPath" select="''"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:if>
	
	<footer>
		<p>
		<input type="button" id="check" value="alle auswählen"/>
		<input type="button" id="uncheck" value="auswahl aufheben"/>
		<input type="button" id="reset" value="alles zurücksetzen"/>
		</p>
		<p>Diese Seite wurde zuletzt generiert am <xsl:call-template name="str:replace">
			<xsl:with-param name="string" select="/indexer[1]/@gendate" />
			<xsl:with-param name="search" select="' '" />
			<xsl:with-param name="replace" select="' um '" />
		</xsl:call-template> Uhr, mit einem Programm von <a href="https://rcl.blackpinguin.de/" target="_blank" rel="noopener">Robin C. Ladiges</a>.</p>
	</footer>
</body>
</html>
</xsl:template>



<!-- Rekursive Funktion: Ausgabe einer Ebene -->
<xsl:template name="layer">
	<!-- Funktionsparameter mit Default-Wert -->
	<xsl:param name="accuPath" select="@url" />
	
	<xsl:variable name="path">
		<xsl:if test="$relPath">
			<xsl:value-of select="/indexer[1]/index[1]/layer[1]/@absPath"/>
			<xsl:text>/</xsl:text>
		</xsl:if>
		<xsl:value-of select="$accuPath" />
	</xsl:variable>
	
	<!-- Funktionskörper -->
	<details>
		<xsl:attribute name="id"><xsl:value-of select="concat('d_', $path)"/></xsl:attribute>
		<summary>
			<xsl:if test="@checkbox and @checkbox = 'true'">
				<input type="checkbox">
					<xsl:attribute name="name"><xsl:value-of select="concat('cb_', $path)"/></xsl:attribute>
				</input>
			</xsl:if>
			
			<span><xsl:value-of select="@name"/></span>
			
			<xsl:choose>
				<!-- Wenn es ein Layer mit eigenen Unterseiten ist -->
				<xsl:when test="not(@checkbox and @checkbox = 'true')">
					<a class="extern">
						<xsl:attribute name="title"><xsl:value-of select="@name"/></xsl:attribute>
						<xsl:attribute name="href"><xsl:value-of select="$accuPath"/>/</xsl:attribute>
					</a>
					<a class="rss">
						<xsl:attribute name="title"><xsl:value-of select="@name"/> als Feed abonnieren (RSS)</xsl:attribute>
						<xsl:attribute name="href"><xsl:value-of select="$accuPath"/>/feed.rss</xsl:attribute>
					</a>
					<a class="json" title="JSON-Daten">
						<xsl:attribute name="href"><xsl:value-of select="$accuPath"/>/data.json</xsl:attribute>
					</a>
					<a class="xml" title="XML-Daten">
						<xsl:attribute name="href"><xsl:value-of select="$accuPath"/>/data.xml</xsl:attribute>
					</a>
				</xsl:when>
				<!-- sonst -->
				<xsl:otherwise>
					<!-- Kommentaranzahl -->
					<xsl:if test="@comments and number(@comments) > 0">
						<span>(<xsl:value-of select="@comments"/>)</span>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
			
		</summary>
		
		<xsl:call-template name="layerDiv">
			<xsl:with-param name="path" select="$path"/>
			<xsl:with-param name="accuPath" select="$accuPath"/>
		</xsl:call-template>
		
	</details>
</xsl:template>




<xsl:template name="layerDiv">
	<xsl:param name="path" />
	<xsl:param name="accuPath" />
	
	<div>
		<xsl:if test="@videos or @duration">
			<div>
				<!-- Videoanzahl -->
				<xsl:if test="@videos">Anzahl Videos: <xsl:value-of select="@videos"/></xsl:if>
				<xsl:if test="@videos and @duration">, </xsl:if>
				<xsl:if test="@duration">Dauer: <xsl:value-of select="@duration"/></xsl:if>
			</div>
		</xsl:if>
			
		<!-- für alle layer Unterelemente -->
		<xsl:for-each select="layer">
			<!-- Rekursionsaufruf mit Parameter -->
			<xsl:call-template name="layer">
				<xsl:with-param name="accuPath">
					<xsl:if test="$accuPath">
						<xsl:value-of select="concat($accuPath, '/')"/>
					</xsl:if>
					<xsl:value-of select="@url"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		
		<!-- für alle vref Unterelemente -->
		<xsl:for-each select="vref">
			<!-- Funktionsaufruf mit Parameter -->
			<xsl:call-template name="vref">
				<xsl:with-param name="pathparam" select="$path"/>
			</xsl:call-template>
		</xsl:for-each>
	</div>
</xsl:template>


<!-- Funktion: Finden und Ausgeben eines Videos anhand der ID -->
<xsl:template name="vref">
	<!-- Funktionsparameter -->
	<xsl:param name="pathparam" />
	
	<xsl:variable name="id" select="@id" />
	<xsl:variable name="title" select="@title" />
	
	<xsl:for-each select="/indexer[1]/videos[1]/video[@id=$id]">
		<xsl:call-template name="video">
			<xsl:with-param name="pathparam" select="concat($pathparam, '/', $title)"/>
			<xsl:with-param name="title" select="$title"/>
		</xsl:call-template>
	</xsl:for-each>
	
</xsl:template>



<!-- Funktion: Ausgabe eines Videos -->
<xsl:template name="video">
	<!-- Funktionsparameter -->
	<xsl:param name="pathparam" />
	<xsl:param name="title" />
	
	<xsl:variable name="path">
		<xsl:call-template name="str:replace">
			<xsl:with-param name="string" select="$pathparam" />
			<xsl:with-param name="search" select="' '" />
			<xsl:with-param name="replace" select="'_'" />
		</xsl:call-template>
	</xsl:variable>
	
	<!-- Funktionskörper -->
	<div>
		<!-- Checkbox -->
		<input type="checkbox">
			<xsl:attribute name="name"><xsl:value-of select="concat('cb_', $path)"/></xsl:attribute>
		</input>
		
		<!-- Link und Titel -->
		<a target="_blank" rel="noopener">
			<xsl:attribute name="href"><xsl:value-of select="@url"/></xsl:attribute>
			<xsl:value-of select="$title"/>
		</a>
		
		<!-- Videodauer, falls vorhanden -->
		<xsl:if test="@duration">
			<span>(<xsl:value-of select="@duration"/>)</span>
		</xsl:if>
		
		<!-- Kommentaranzahl, falls vorhanden -->
		<xsl:if test="@comments">
			<span>(<xsl:value-of select="@comments"/> Kommentar<xsl:if test="number(@comments) != 1">e</xsl:if>)</span>
		</xsl:if>
		
		<!-- Videodateien -->
		<xsl:for-each select="file">
			<a target="_blank" rel="noopener">
				<xsl:attribute name="href"><xsl:value-of select="@url"/></xsl:attribute>
				<xsl:value-of select="concat('[',@type,']')"/>
			</a>
		</xsl:for-each>
		
		<!-- Button um den eigebetteten Player zu öffnen -->
		<a class="videobtn">
			<!-- <img src="play.png" class="videobtn" /> -->
		</a>
		
	</div>
</xsl:template>



</xsl:stylesheet>

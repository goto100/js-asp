<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="common.xsl"/>

	<xsl:template match="/" mode="default">
		<xsl:param name="title"/>
		<xsl:param name="script"/>
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
				<link type="text/css" rel="stylesheet" href="{$rootStr}skins/default/styles/{$sys.setting.defaultStyle}/common/default.css"/>
				<script type="text/javascript" src="{$rootStr}common/functions.js"></script>
				<script type="text/javascript" src="{$rootStr}skins/default/script/common/common.js"></script>
				<xsl:if test="$script">
					<script type="text/javascript" src="{$rootStr}skins/default/script/{$script}"></script>
				</xsl:if>
				<title><xsl:value-of select="$title"/> - <xsl:value-of select="$sys.setting.siteName"/></title>
			</head>
			<body id="page-{/@type}">
				<div id="wrapper">
					<div id="innerWrapper">
						<xsl:call-template name="header">
							<xsl:with-param name="title"><xsl:value-of select="$title"/></xsl:with-param>
						</xsl:call-template>
						<div id="ContentWrapper">
							<div id="Content">
								<xsl:for-each select="/*">
									<div id="{name()}">
										<xsl:apply-templates select="."/>
									</div>
								</xsl:for-each>
							</div>
							<xsl:call-template name="sidebar"/>
							<div class="clear"></div>
						</div>
						<xsl:call-template name="footer"/>
					</div>
				</div>
			</body>
		</html>
	</xsl:template>

	<xsl:template name="header">
		<xsl:param name="title"/>
		<div id="Header">
			<xsl:call-template name="navbar"/>
			<div id="title"><h1><xsl:copy-of select="$title"/></h1></div>
			<xsl:apply-templates select="/*/user"/>
		</div>
	</xsl:template>

	<xsl:template name="footer">
		<div id="Footer">

		</div>
	</xsl:template>

	<xsl:template name="sidebar">
		<div id="Sidebar">

		</div>
	</xsl:template>

</xsl:stylesheet>

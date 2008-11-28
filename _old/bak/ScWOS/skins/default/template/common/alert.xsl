<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="common.xsl"/>

	<xsl:template match="/*[@type = 'msg']" mode="error">
		<xsl:param name="title">错误</xsl:param>
		<xsl:call-template name="alert">
			<xsl:with-param name="title" select="$title"/>
			<xsl:with-param name="content">
				<div id="msg" class="error">
					<h1><xsl:value-of select="$title"/></h1>
					<p><xsl:value-of select="."/></p>
					<p><a href="{/*/@referer}">返回</a></p>
				</div>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="/*[@type = 'msg']" mode="success">
		<xsl:param name="title">成功</xsl:param>
		<xsl:call-template name="alert">
			<xsl:with-param name="title" select="$title"/>
			<xsl:with-param name="content">
				<div id="msg" class="success">
					<h1><xsl:value-of select="$title"/></h1>
					<p><xsl:value-of select="."/></p>
					<p><a href="{/*/@referer}">返回</a></p>
				</div>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="alert">
		<xsl:param name="title"/>
		<xsl:param name="content"/>
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
				<link type="text/css" rel="stylesheet" href="{$rootStr}skins/default/styles/{$sys.setting.defaultStyle}/common/alert.css"/>
				<title><xsl:value-of select="$title"/></title>
			</head>
			<body id="page-{name(/*)}">
				<div id="wrapper">
					<div id="innerWrapper">
						<xsl:copy-of select="$content"/>
					</div>
				</div>
			</body>
		</html>
	</xsl:template>

</xsl:stylesheet>

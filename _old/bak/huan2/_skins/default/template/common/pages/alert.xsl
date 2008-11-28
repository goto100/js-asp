<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:page="huan:page">
	<xsl:import href="../templates/panel.xsl" />
	<xsl:import href="../templates/navbar.xsl" />

	<xsl:template match="/" mode="alert">
		<xsl:param name="rootPath" select="/*/@page:rootPath" />
		<xsl:param name="title" />
		<xsl:param name="contentNode" select="*[namespace-uri() != 'huan:page']" />

		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
				<link type="text/css" rel="stylesheet" href="{$rootPath}_skins/default/styles/{$system.setting/defaultStyle}/common.css" />
				<script type="text/javascript" src="{$rootPath}_skins/default/script/common.js"></script>
				<title><xsl:value-of select="$title" /></title>
			</head>
			<body class="alert">
				<div id="Wrapper">
					<div id="InnerWrapper">
						<div id="Header">
							<p id="logo"><a href="{$rootPath}."><img src="{$rootPath}_skins/default/template/images/logo.png" alt="返回首页" /></a></p>
							<xsl:call-template name="panel">
								<xsl:with-param name="rootPath" select="$rootPath" />
							</xsl:call-template>
							<xsl:call-template name="navbar">
								<xsl:with-param name="rootPath" select="$rootPath" />
							</xsl:call-template>
						</div>
						<div id="ContentWrapper">
							<div id="Content">
								<h1><xsl:copy-of select="$title" /></h1>
								<div id="msg">
									<xsl:apply-templates select="$contentNode" />
									<a href="javascript:history.go(-1)">返回上一页</a>
								</div>
							</div>
						</div>
						<div id="Footer">
							<p>Runtime: <xsl:value-of select="/*/@page:runtime" /> ms</p>
							<p>DB Executes: <xsl:value-of select="/*/@page:executeCount" /></p>
						</div>
					</div>
				</div>
			</body>
		</html>
	</xsl:template>

</xsl:stylesheet>

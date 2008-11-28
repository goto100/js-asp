<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:page="huan:page">

	<xsl:template name="panel">
		<xsl:param name="rootPath" />
		<xsl:param name="visitorNode" select="/*/page:visitor" />

		<ul id="panel">
			<li><a href="{$rootPath}user">在线</a></li>
			<li><a href="{$rootPath}user">成员</a></li>
			<xsl:choose>
				<xsl:when test="$visitorNode/@loggedIn = '-1'">
					<li><a href="{$rootPath}user/logout">登出</a></li>
					<li><a href="{$rootPath}user/message">消息</a></li>
					<li><a href="{$rootPath}user/panel">控制面板</a></li>
				</xsl:when>
				<xsl:otherwise>
					<li><a href="{$rootPath}user/register">注册</a></li>
					<li><a href="{$rootPath}user/login">登录</a></li>
				</xsl:otherwise>
			</xsl:choose>
			<li><a href="{$rootPath}admin">管理</a></li>
		</ul>
	</xsl:template>

	<xsl:template match="/*/page:visitor">
	</xsl:template>

</xsl:stylesheet>
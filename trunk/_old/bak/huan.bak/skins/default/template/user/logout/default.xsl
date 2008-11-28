<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../../common.xsl" />

	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="loggedOut">
				<xsl:apply-templates select="." mode="alert">
					<xsl:with-param name="title">登出成功</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>

			<xsl:when test="notLoggedIn">
				<xsl:apply-templates select="." mode="alert">
					<xsl:with-param name="title">您还未登录</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>

			<xsl:otherwise><xsl:apply-imports /></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
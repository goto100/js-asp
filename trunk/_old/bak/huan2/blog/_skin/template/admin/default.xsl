<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../common.xsl" />
	<xsl:import href="../common/templates/adminPanel.xsl" />

	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="systemInfo">
				<xsl:apply-templates select="." mode="default">
					<xsl:with-param name="title">系统信息</xsl:with-param>
					<xsl:with-param name="sidebar"><xsl:call-template name="adminPanel"><xsl:with-param name="adminPath"></xsl:with-param></xsl:call-template></xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>

			<xsl:otherwise><xsl:apply-imports /></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="/systemInfo">
		<div id="systemInfo">
			<p><a href="?buildcache">重建缓存文件</a></p>
			<xsl:apply-templates />
		</div>
	</xsl:template>

</xsl:stylesheet>
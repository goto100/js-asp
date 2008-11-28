<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../huan/common.xsl" />

	<xsl:template match="/">
		<xsl:apply-templates select="." mode="alert">
			<xsl:with-param name="title">
				<xsl:choose>
					<xsl:when test="noPermission">没有权限</xsl:when>
					<xsl:when test="siteClosed">网站关闭</xsl:when>
					<xsl:when test="badURL">访问错误</xsl:when>
					<xsl:otherwise>未指定模板</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

</xsl:stylesheet>
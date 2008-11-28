<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="common/pages/default.xsl" />
	<xsl:import href="common/pages/alert.xsl" />
	<xsl:output method="html" encoding="gb2312" omit-xml-declaration="yes" doctype-public="-//W3C//XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" />
	
	<xsl:variable name="system.setting" select="document('../../../cache/setting.xml')/setting" />
	<xsl:variable name="system.userGroups" select="document('../../../cache/userGroups.xml')/userGroups" />
	<xsl:variable name="system.category" select="document('../../../cache/category.xml')/category" />

	<xsl:template match="/">
		<xsl:apply-templates select="." mode="alert">
			<xsl:with-param name="title">
				<xsl:choose>
					<xsl:when test="noPermission">没有权限</xsl:when>
					<xsl:when test="siteClosed">网站关闭</xsl:when>
					<xsl:when test="badURL">访问错误</xsl:when>
					<xsl:otherwise>未设定模板</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

</xsl:stylesheet>
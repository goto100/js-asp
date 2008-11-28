<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../../common.xsl" />
	<xsl:import href="../../common/templates/adminPanel.xsl" />

	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="/form">
				<xsl:apply-templates select="." mode="default">
					<xsl:with-param name="title">系统设置</xsl:with-param>
					<xsl:with-param name="sidebar"><xsl:call-template name="adminPanel" /></xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>

			<xsl:otherwise><xsl:apply-imports /></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="/form">
		<xsl:apply-templates select="." mode="form">
			<xsl:with-param name="action">?submit</xsl:with-param>
			<xsl:with-param name="content">
				<xsl:apply-templates select="setting" />
				<xsl:apply-templates select="." mode="form.submit" />
				<xsl:apply-templates select="." mode="form.reset" />
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="form/setting">
		<fieldset>
			<legend>站点信息</legend>
			<xsl:apply-templates select="siteName" mode="form.text">
				<xsl:with-param name="label">网站名称：</xsl:with-param>
				<xsl:with-param name="size">60</xsl:with-param>
			</xsl:apply-templates>
			<xsl:apply-templates select="siteURL" mode="form.text">
				<xsl:with-param name="label">网站地址：</xsl:with-param>
				<xsl:with-param name="size">60</xsl:with-param>
			</xsl:apply-templates>
			<xsl:apply-templates select="defaultLanguage" mode="form.text">
				<xsl:with-param name="label">默认语言：</xsl:with-param>
				<xsl:with-param name="size">25</xsl:with-param>
			</xsl:apply-templates>
			<xsl:apply-templates select="siteOpened" mode="form.checkbox">
				<xsl:with-param name="label">网站开启：</xsl:with-param>
			</xsl:apply-templates>
		</fieldset>
	</xsl:template>


</xsl:stylesheet>
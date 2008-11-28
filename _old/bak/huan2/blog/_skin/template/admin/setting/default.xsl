<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../../common.xsl" />
	<xsl:import href="../../common/templates/adminPanel.xsl" />

	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="form">
				<xsl:apply-templates select="." mode="default">
					<xsl:with-param name="title">Blog 设置</xsl:with-param>
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

	<xsl:template match="/form/setting">
		<fieldset>
			<legend>Blog 信息</legend>
			<xsl:apply-templates select="blogName" mode="form.text">
				<xsl:with-param name="label">Blog 名称：</xsl:with-param>
				<xsl:with-param name="size">60</xsl:with-param>
			</xsl:apply-templates>
			<xsl:apply-templates select="blogTitle" mode="form.text">
				<xsl:with-param name="label">Blog 标题：</xsl:with-param>
				<xsl:with-param name="size">60</xsl:with-param>
			</xsl:apply-templates>
			<xsl:apply-templates select="blogURL" mode="form.text">
				<xsl:with-param name="label">Blog 地址：</xsl:with-param>
				<xsl:with-param name="description">（保证 RSS 的可读性）</xsl:with-param>
				<xsl:with-param name="size">60</xsl:with-param>
			</xsl:apply-templates>
			<xsl:apply-templates select="masterName" mode="form.text">
				<xsl:with-param name="label">站长昵称：</xsl:with-param>
				<xsl:with-param name="size">20</xsl:with-param>
			</xsl:apply-templates>
			<xsl:apply-templates select="masterEmail" mode="form.text">
				<xsl:with-param name="label">站长邮箱：</xsl:with-param>
				<xsl:with-param name="size">50</xsl:with-param>
			</xsl:apply-templates>
		</fieldset>
	</xsl:template>

</xsl:stylesheet>
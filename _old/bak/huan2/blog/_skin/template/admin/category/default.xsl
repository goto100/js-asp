<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../../common.xsl" />
	<xsl:import href="../../common/templates/adminPanel.xsl" />

	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="category">
				<xsl:apply-templates select="." mode="default">
					<xsl:with-param name="title">分类列表</xsl:with-param>
					<xsl:with-param name="sidebar"><xsl:call-template name="adminPanel" /></xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>

			<xsl:when test="add">
				<xsl:apply-templates select="." mode="default">
					<xsl:with-param name="title">添加分类</xsl:with-param>
					<xsl:with-param name="sidebar"><xsl:call-template name="adminPanel" /></xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>

			<xsl:when test="edit">
				<xsl:apply-templates select="." mode="default">
					<xsl:with-param name="title">编辑分类</xsl:with-param>
					<xsl:with-param name="sidebar"><xsl:call-template name="adminPanel" /></xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>

			<xsl:otherwise><xsl:apply-imports /></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="/category">
		<xsl:apply-templates select="." mode="category" />
	</xsl:template>

	<xsl:template match="/add | /edit">
		<xsl:apply-templates select="." mode="form">
			<xsl:with-param name="content">
				<xsl:apply-templates select="category | save" />
				<xsl:apply-templates select="." mode="form.submit" />
				<xsl:apply-templates select="." mode="form.reset" />
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="/add/category | /edit/category">
		<fieldset>
			<legend>基本信息</legend>
			<xsl:apply-templates select="id" mode="form.hidden" />
			<xsl:apply-templates select="name" mode="form.text">
				<xsl:with-param name="label">名称：</xsl:with-param>
				<xsl:with-param name="size">50</xsl:with-param>
			</xsl:apply-templates>
			<xsl:apply-templates select="parentId" mode="form.select1">
				<xsl:with-param name="label">所属分类：</xsl:with-param>
				<xsl:with-param name="items">
					<xsl:apply-templates select="." mode="form.option">
						<xsl:with-param name="label">[根类]</xsl:with-param>
						<xsl:with-param name="value" select="0" />
					</xsl:apply-templates>
					<xsl:apply-templates select="../category/category" />
				</xsl:with-param>
			</xsl:apply-templates>
			<xsl:apply-templates select="description" mode="form.text">
				<xsl:with-param name="label">描述：</xsl:with-param>
				<xsl:with-param name="size">70</xsl:with-param>
			</xsl:apply-templates>
			<xsl:apply-templates select="articleCount" mode="form.text">
				<xsl:with-param name="label">文章数：</xsl:with-param>
				<xsl:with-param name="size">4</xsl:with-param>
			</xsl:apply-templates>
		</fieldset>
	</xsl:template>

	<xsl:template match="/add/category//category">
		<xsl:param name="prefix"> </xsl:param>

		<xsl:apply-templates select="." mode="form.option">
			<xsl:with-param name="label" select="concat($prefix, ' ', @name)" />
			<xsl:with-param name="value" select="@id" />
			<xsl:with-param name="selectedValue" select="/add/category/parentId" />
		</xsl:apply-templates>
		<xsl:if test="category">
			<xsl:apply-templates>
				<xsl:with-param name="prefix" select="concat($prefix, '-')" />
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsl:template match="/add/save">
		<fieldset>
			<legend>添加选项</legend>
			<xsl:apply-templates select="action" mode="form.select1">
				<xsl:with-param name="appearance">full</xsl:with-param>
				<xsl:with-param name="label">添加后：</xsl:with-param>
				<xsl:with-param name="items">
					<xsl:apply-templates mode="form.radio">
						<xsl:with-param name="label">继续添加</xsl:with-param>
						<xsl:with-param name="value">continueAdd</xsl:with-param>
					</xsl:apply-templates>
					<xsl:apply-templates mode="form.radio">
						<xsl:with-param name="label">返回列表</xsl:with-param>
						<xsl:with-param name="value">list</xsl:with-param>
					</xsl:apply-templates>
				</xsl:with-param>
			</xsl:apply-templates>
		</fieldset>
	</xsl:template>

</xsl:stylesheet>
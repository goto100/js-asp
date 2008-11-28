<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../../common.xsl" />
	<xsl:import href="../../common/templates/adminPanel.xsl" />

	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="skins">
				<xsl:apply-templates select="." mode="default">
					<xsl:with-param name="title">皮肤列表</xsl:with-param>
					<xsl:with-param name="sidebar"><xsl:call-template name="adminPanel" /></xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>

			<xsl:when test="skin">
				<xsl:apply-templates select="." mode="default">
					<xsl:with-param name="title"><xsl:value-of select="skin/name" /></xsl:with-param>
					<xsl:with-param name="sidebar"><xsl:call-template name="adminPanel" /></xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>

			<xsl:otherwise><xsl:apply-imports /></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="/skins">
		<xsl:apply-templates select="." mode="listTable">
			<xsl:with-param name="colCount">5</xsl:with-param>
			<xsl:with-param name="emptyMsg">未安装皮肤。</xsl:with-param>
			<xsl:with-param name="head">
				<tr>
					<th scope="col"></th>
					<th scope="col">名称</th>
					<th scope="col">版本</th>
					<th scope="col">作者</th>
					<th scope="col">默认</th>
				</tr>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="/skins/item">
		<xsl:element name="tr" use-attribute-sets="listTable.row">
			<td><xsl:number /></td>
			<th scope="row"><xsl:value-of select="name" /></th>
			<td><xsl:value-of select="version" /></td>
			<td><xsl:value-of select="author" /></td>
			<td>
				<xsl:choose>
					<xsl:when test="@isDefault">√ <a href="?default">设置风格</a></xsl:when>
					<xsl:otherwise><a href="?setdefault&amp;id={@id}">设置成默认</a></xsl:otherwise>
				</xsl:choose>
			</td>
		</xsl:element>
	</xsl:template>

	<xsl:template match="/skin">
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="/skin/styles">
		<xsl:apply-templates select="." mode="listTable">
			<xsl:with-param name="colCount">5</xsl:with-param>
			<xsl:with-param name="emptyMsg">未安装皮肤。</xsl:with-param>
			<xsl:with-param name="head">
				<tr>
					<th scope="col"></th>
					<th scope="col">名称</th>
					<th scope="col">版本</th>
					<th scope="col">作者</th>
					<th scope="col">默认</th>
				</tr>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="/skin/styles/style">
		<xsl:element name="tr" use-attribute-sets="listTable.row">
			<td><xsl:number /></td>
			<th scope="row"><xsl:value-of select="name" /></th>
			<td><xsl:value-of select="version" /></td>
			<td><xsl:value-of select="author" /></td>
			<td>
				<xsl:choose>
					<xsl:when test="@isDefault">√</xsl:when>
					<xsl:otherwise><a href="?setdefaultstyle&amp;id={@id}">设置成默认</a></xsl:otherwise>
				</xsl:choose>
			</td>
		</xsl:element>
	</xsl:template>

</xsl:stylesheet>
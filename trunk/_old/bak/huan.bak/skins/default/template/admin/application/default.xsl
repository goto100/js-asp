<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../../common.xsl" />
	<xsl:import href="../../common/templates/adminPanel.xsl" />

	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="applications">
				<xsl:apply-templates select="." mode="default">
					<xsl:with-param name="title">系统程序</xsl:with-param>
					<xsl:with-param name="sidebar"><xsl:call-template name="adminPanel" /></xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>

			<xsl:otherwise><xsl:apply-imports /></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="/applications">
		<xsl:apply-templates select="." mode="listTable">
			<xsl:with-param name="colCount">8</xsl:with-param>
			<xsl:with-param name="emptyMsg">未安装系统！</xsl:with-param>
			<xsl:with-param name="head">
				<tr>
					<th scope="col">id</th>
					<th scope="col">管理</th>
				</tr>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="/applications/item">
		<xsl:element name="tr" use-attribute-sets="listTable.row">
			<td><xsl:value-of select="@id" /></td>
			<td><a href="/{path}admin/">管理</a></td>
		</xsl:element>
	</xsl:template>

</xsl:stylesheet>
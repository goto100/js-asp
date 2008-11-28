<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../../common.xsl" />
	<xsl:import href="../../common/templates/adminPanel.xsl" />

	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="visitors">
				<xsl:apply-templates select="." mode="default">
					<xsl:with-param name="title">访问统计</xsl:with-param>
					<xsl:with-param name="sidebar"><xsl:call-template name="adminPanel" /></xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>

			<xsl:otherwise><xsl:apply-imports /></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="/visitors">
		<xsl:apply-templates select="." mode="listTable">
			<xsl:with-param name="colCount">6</xsl:with-param>
			<xsl:with-param name="emptyMsg">没有记录！</xsl:with-param>
			<xsl:with-param name="head">
				<tr>
					<th scope="col">IP</th>
					<th scope="col">时间</th>
					<th scope="col">操作系统</th>
					<th scope="col">浏览器</th>
					<th scope="col">来源</th>
					<th scope="col">目标</th>
				</tr>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="/visitors/item">
		<xsl:element name="tr" use-attribute-sets="listTable.row">
			<th scope="row"><a href="http://ip.cn/ip.php?q={ip}"><xsl:value-of select="ip" /></a></th>
			<td><xsl:value-of select="time" /></td>
			<td><xsl:value-of select="os" /></td>
			<td><xsl:value-of select="browser" /></td>
			<td><xsl:if test="referer/text()"><a href="{referer}" title="{referer}">来源</a></xsl:if></td>
			<td><xsl:if test="target/text()"><a href="{target}" title="{target}">目标</a></xsl:if></td>
		</xsl:element>
	</xsl:template>

</xsl:stylesheet>
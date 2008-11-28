<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../common.xsl" />

	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="users">
				<xsl:apply-templates select="." mode="default">
					<xsl:with-param name="title">在线用户</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>

			<xsl:otherwise><xsl:apply-imports /></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="/users">
		<xsl:apply-templates select="." mode="listTable">
			<xsl:with-param name="colCount">4</xsl:with-param>
			<xsl:with-param name="emptyMsg">当前没有用户在线！</xsl:with-param>
			<xsl:with-param name="head">
				<tr>
					<th scope="col">昵称</th>
					<th scope="col">访问时间</th>
					<th scope="col">在线时长</th>
					<th scope="col">IP</th>
				</tr>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="/users/item">
		<xsl:element name="tr" use-attribute-sets="listTable.row">
			<th scope="row">
				<xsl:choose>
					<xsl:when test="@id != '0'">
						<a href="../../../../skins/default/template/user/?id={@id}"><xsl:value-of select="nickname" /></a>
					</xsl:when>
					<xsl:otherwise>游客</xsl:otherwise>
				</xsl:choose>
			</th>
			<td><xsl:value-of select="visitTime" /></td>
			<td><xsl:value-of select="onlineTime" /> 分钟</td>
			<td><xsl:value-of select="ip" /></td>
		</xsl:element>
	</xsl:template>

</xsl:stylesheet>
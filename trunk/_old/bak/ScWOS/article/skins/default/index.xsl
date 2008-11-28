<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../common/default.xsl"/>
	<xsl:import href="../common/alert.xsl"/>

	<xsl:variable name="rootStr">../</xsl:variable>

	<xsl:template match="/">
		<xsl:variable name="title"><a href="article.asp">文章</a> - </xsl:variable>
		<xsl:choose>
			<xsl:when test="articles">
				<xsl:apply-templates select="." mode="default">
					<xsl:with-param name="title"><xsl:copy-of select="$title"/>
						<xsl:choose>
							<xsl:when test="articles">列表</xsl:when>
							<xsl:when test="add">添加</xsl:when>
							<xsl:when test="edit">编辑</xsl:when>
						</xsl:choose>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-imports/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="/articles">
		<h2>文章列表</h2>
		<xsl:call-template name="listTable">
			<xsl:with-param name="cols" select="5"/>
			<xsl:with-param name="head">
				<th scope="col">序号</th>
				<th scope="col">分类</th>
				<th scope="col">标题</th>
				<th scope="col">作者</th>
				<th scope="col">发布时间</th>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="/articles/article">
		<th scope="row"><xsl:number/></th>
		<td><a href="?cid={category/@id}"><xsl:value-of select="category"/></a></td>
		<td><a href="article.asp?id={@id}"><xsl:value-of select="title"/></a></td>
		<td><xsl:value-of select="author"/></td>
		<td><xsl:value-of select="time"/></td>
	</xsl:template>

</xsl:stylesheet>

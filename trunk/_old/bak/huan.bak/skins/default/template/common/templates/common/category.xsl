<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="*" mode="category">
		<xsl:param name="id">category</xsl:param>
		<xsl:param name="emptyMsg">暂时没有分类。</xsl:param>

		<xsl:choose>
			<xsl:when test="category">
				<ul class="tree">
					<xsl:if test="$id">
						<xsl:attribute name="id"><xsl:value-of select="$id" /></xsl:attribute>
					</xsl:if>
					<xsl:apply-templates select="category" mode="category.item" />
				</ul>
			</xsl:when>
			<xsl:otherwise>
				<p><xsl:value-of select="$emptyMsg" /></p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="category" mode="category.item">
		<xsl:param name="name" select="name" />
		<xsl:param name="id" select="@id" />
		<xsl:param name="isLeaf" select="not(category)" />
		<xsl:param name="isFirst" select="position() = 1" />
		<xsl:param name="isLast" select="position() = last()" />

		<li><xsl:value-of select="$name" />
			<span class="add"><a href="common/?add&amp;parentId={$id}" title="添加">添加</a></span>
			<xsl:if test="not($isFirst)">
				<span class="up"><a href="common/?up&amp;id={$id}" title="向上">向上</a></span>
			</xsl:if>
			<xsl:if test="not($isLast)">
				<span class="down"><a href="common/?down&amp;id={$id}" title="向下">向下</a></span>
			</xsl:if>
			<span class="edit"><a href="common/?edit&amp;id={$id}" title="编辑">编辑</a></span>
			<xsl:if test="$isLeaf"><span class="del"><a href="common/?delete&amp;id={$id}" title="删除">删除</a></span></xsl:if>
			<xsl:if test="category">
				<ul><xsl:apply-templates select="category" mode="category.item" /></ul>
			</xsl:if>
		</li>
	</xsl:template>

</xsl:stylesheet>
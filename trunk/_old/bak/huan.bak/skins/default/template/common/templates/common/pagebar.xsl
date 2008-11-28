<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="*" mode="pagebar">
		<xsl:param name="total" select="15" />
		<xsl:param name="left" select="5" />
		<xsl:param name="pageCount" select="number(@pageCount)" />
		<xsl:param name="currentPage" select="number(@currentPage)" />

		<xsl:variable name="right" select="$total - $left" />
		<xsl:variable name="count">
			<xsl:choose>
				<xsl:when test="$pageCount &lt; $total">
					<xsl:value-of select="$pageCount" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$total" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="start">
			<xsl:choose>
				<xsl:when test="$currentPage &lt; $left + 1">1</xsl:when>
				<xsl:when test="$currentPage + $right &gt; $pageCount">
					<xsl:value-of select="$pageCount - $count + 1" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$currentPage - $left" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<div class="pagebar">
			<xsl:choose>
				<xsl:when test="$currentPage &gt; 1">
					<p class="previous"><a href="common/?page={$currentPage - 1}" title="上一页">&lt;</a></p>
				</xsl:when>
				<xsl:otherwise>
					<p class="previous">&lt;</p>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="$currentPage &lt; $pageCount">
					<p class="next"><a href="common/?page={$currentPage + 1}" title="下一页">&gt;</a></p>
				</xsl:when>
				<xsl:otherwise>
					<p class="next">&gt;</p>
				</xsl:otherwise>
			</xsl:choose>
			<ul>
				<xsl:if test="$start &gt; 1">
					<li class="first"><a href="common/?page=1" title="首页">&lt;&lt;</a></li>
				</xsl:if>
				<xsl:apply-templates select="." mode="pagebar.item">
					<xsl:with-param name="total" select="$count" />
					<xsl:with-param name="start" select="$start" />
				</xsl:apply-templates>
				<xsl:if test="$start + $count &lt; $pageCount + 1">
					<li class="last"><a href="common/?page={$pageCount}" title="末页">&gt;&gt;</a></li>
				</xsl:if>
			</ul>
			<p class="total"><xsl:value-of select="$currentPage" /> / <xsl:value-of select="$pageCount" /></p>
		</div>
	</xsl:template>

	<xsl:template match="*" mode="pagebar.item">
		<xsl:param name="start" select="1" />
		<xsl:param name="total" select="number(@pageCount)" />
		<xsl:variable name="currentPage" select="number(@currentPage)" />
		<xsl:if test="$total > 0">
			<xsl:choose>
				<xsl:when test="$start = $currentPage">
					<li class="current"><xsl:value-of select="$start" /></li>
				</xsl:when>
				<xsl:otherwise>
					<li class="item"><a href="common/?page={$start}" title="第 {$start} 页"><xsl:value-of select="$start" /></a></li>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="." mode="pagebar.item">
				<xsl:with-param name="total" select="$total - 1" />
				<xsl:with-param name="start" select="$start + 1" />
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>

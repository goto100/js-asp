<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="order" mode="orderPanel">
		<div class="panel">
			<h2>排序</h2>
			<ul>
				<xsl:apply-templates select="*" mode="orderPanel" />
			</ul>
		</div>
	</xsl:template>

	<xsl:template match="order/*" mode="orderPanel">
		<xsl:variable name="name" select="name() "/>

		<li>
			<a>
				<xsl:attribute name="href">
					<xsl:text>?orders=</xsl:text>
					<xsl:value-of select="name()" />
					<xsl:if test="@isDesc = '0'">~</xsl:if>
					<xsl:for-each select="../*[name() != $name]">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="name()" />
						<xsl:if test="@isDesc = '-1'">~</xsl:if>
					</xsl:for-each>
				</xsl:attribute>
				<xsl:apply-templates select="." />
			</a>
		</li>
	</xsl:template>

</xsl:stylesheet>
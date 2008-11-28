<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../common/default.xsl"/>
	<xsl:import href="../common/alert.xsl"/>

	<xsl:variable name="rootStr">../</xsl:variable>

	<xsl:template match="/">
		<xsl:variable name="title">设置 - </xsl:variable>
		<xsl:choose>
			<xsl:when test="settings">
				<xsl:apply-templates select="." mode="default">
					<xsl:with-param name="title"><xsl:copy-of select="$title"/>
						<xsl:choose>
							<xsl:when test="settings">列表</xsl:when>
						</xsl:choose>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>

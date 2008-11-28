<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../../common/default.xsl"/>
	<xsl:import href="../../common/alert.xsl"/>
	<xsl:import href="../../admin/category.xsl"/>

	<xsl:variable name="rootStr">../../</xsl:variable>

	<xsl:template match="/">
		<xsl:apply-imports/>
	</xsl:template>

</xsl:stylesheet>

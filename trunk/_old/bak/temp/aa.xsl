<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:test="test"
>

	<xsl:template match="/">
		<xsl:value-of select="root/test:test" />
	</xsl:template>

</xsl:stylesheet>
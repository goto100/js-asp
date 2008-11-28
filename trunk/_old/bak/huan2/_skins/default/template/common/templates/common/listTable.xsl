<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="*" mode="listTable">
		<xsl:param name="head" />
		<xsl:param name="bodyNode" select="item" />
		<xsl:param name="colCount" />
		<xsl:param name="emptyMsg" />
		<xsl:param name="pageCount" select="@pageCount" />
		<xsl:param name="currentPage" select="number(@currentPage)" />
		<xsl:param name="pageSize" select="@pageSize" />
		<xsl:param name="recordCount" select="@recordCount" />
		<xsl:param name="isEmpty" select="not($bodyNode)" />
		<xsl:variable name="endRecord" select="$currentPage * $pageSize" />
		<xsl:variable name="startRecord" select="$endRecord - $pageSize + 1" />

		<xsl:choose>
			<xsl:when test="$isEmpty"><p class="msg"><xsl:value-of select="$emptyMsg" /></p></xsl:when>
			<xsl:otherwise>
				<xsl:if test="$pageCount"><xsl:apply-templates select="." mode="pagebar" /></xsl:if>
				<table class="list">
					<thead>
						<xsl:copy-of select="$head" />
					</thead>
					<tfoot>
						<td colspan="{$colCount}">
							<xsl:if test="$pageSize">
								<xsl:choose>
									<xsl:when test="$recordCount &lt; $endRecord"><xsl:value-of select="$startRecord" /> - <xsl:value-of select="$recordCount" /> / <xsl:value-of select="$recordCount" /></xsl:when>
									<xsl:otherwise><xsl:value-of select="$startRecord" /> - <xsl:value-of select="$endRecord" /> / <xsl:value-of select="$recordCount" /></xsl:otherwise>
								</xsl:choose>
							</xsl:if>
						</td>
					</tfoot>
					<tbody>
						<xsl:apply-templates select="$bodyNode" />
					</tbody>
				</table>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:attribute-set name="listTable.row">
		<xsl:attribute name="class">
			<xsl:choose>
				<xsl:when test="position() mod(2) = 0">row1</xsl:when>
				<xsl:otherwise>row2</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:attribute-set>

</xsl:stylesheet>

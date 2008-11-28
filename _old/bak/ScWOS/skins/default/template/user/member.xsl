<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../common/default.xsl"/>
	<xsl:import href="../common/alert.xsl"/>

	<xsl:variable name="rootStr">../</xsl:variable>

	<xsl:template match="/">
		<xsl:variable name="title"><a href="member.asp">成员</a> - </xsl:variable>
		<xsl:choose>
			<xsl:when test="members | member">
				<xsl:apply-templates select="." mode="default">
					<xsl:with-param name="title"><xsl:copy-of select="$title"/>
						<xsl:choose>
							<xsl:when test="members">列表</xsl:when>
							<xsl:when test="member"><xsl:value-of select="member/nickname"/> - 查看</xsl:when>
						</xsl:choose>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="empty">
				<xsl:apply-templates select="*[@type = 'msg']" mode="error">
					<xsl:with-param name="title"><xsl:copy-of select="$title"/>
						<xsl:choose>
							<xsl:when test="empty">无此成员</xsl:when>
						</xsl:choose>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-imports/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="/members">
		<h2>本站成员列表</h2>
		<xsl:call-template name="listTable">
			<xsl:with-param name="cols">4</xsl:with-param>
			<xsl:with-param name="msg">暂时没有用户。</xsl:with-param>
			<xsl:with-param name="head">
				<th scope="col">序号</th>
				<th scope="col">E'mail</th>
				<th scope="col">所属组</th>
				<th scope="col">查看</th>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="/members/member">
		<th scope="row"><xsl:number/></th>
		<td><a href="mailto:{email}"><xsl:value-of select="email"/></a></td>
		<td><xsl:value-of select="group"/></td>
		<td><a href="member.asp?id={@id}">查看</a></td>
	</xsl:template>

	<xsl:template match="/member">
		<h2>成员 <xsl:value-of select="nickname"/> 的资料</h2>
		<dl class="list">
			<dt>Email</dt>
			<dd><xsl:value-of select="email"/></dd>
			<dt>昵称</dt>
			<dd><xsl:value-of select="nickname"/></dd>
			<dt>性别</dt>
			<dd><xsl:value-of select="gender"/></dd>
			<dt>用户组</dt>
			<dd><xsl:value-of select="group"/></dd>
		</dl>
	</xsl:template>

</xsl:stylesheet>

<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../common.xsl" />

	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="members">
				<xsl:apply-templates select="." mode="default">
					<xsl:with-param name="title">用户列表</xsl:with-param>
					<xsl:with-param name="sidebar">
						<div class="panel">
							<h2>搜索用户</h2>
						</div>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>

			<xsl:when test="member">
				<xsl:apply-templates select="." mode="default">
					<xsl:with-param name="title"><xsl:value-of select="member/nickname" /></xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>

			<xsl:otherwise><xsl:apply-imports /></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="/members">
		<xsl:apply-templates select="." mode="listTable">
			<xsl:with-param name="colCount">5</xsl:with-param>
			<xsl:with-param name="emptyMsg">暂时没有用户！</xsl:with-param>
			<xsl:with-param name="head">
				<tr>
					<th scope="col">Email</th>
					<th scope="col">昵称</th>
					<th scope="col">注册时间</th>
					<th scope="col">最后访问时间</th>
					<th scope="col">IP</th>
				</tr>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="/members/item">
		<xsl:element name="tr" use-attribute-sets="listTable.row">
			<th scope="row"><a href="?id={@id}"><xsl:value-of select="userId" /></a></th>
			<td><xsl:value-of select="nickname" /></td>
			<td><xsl:value-of select="regTime" /></td>
			<td><xsl:value-of select="lastVisitTime" /></td>
			<td><xsl:value-of select="lastIP" /></td>
		</xsl:element>
	</xsl:template>

	<xsl:template match="/add">
		<xsl:apply-templates select="." mode="form">
			<xsl:with-param name="action">?save</xsl:with-param>
			<xsl:with-param name="content">
				<xsl:apply-templates select="member" />
				<xsl:apply-templates select="." mode="form.submit" />
				<xsl:apply-templates select="." mode="form.reset" />
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="/add/member">
		<fieldset>
			<legend>基本信息</legend>
			<xsl:apply-templates select="userId" mode="form.text">
				<xsl:with-param name="label">Email：</xsl:with-param>
				<xsl:with-param name="size">65</xsl:with-param>
			</xsl:apply-templates>
			<xsl:apply-templates select="password" mode="form.secret">
				<xsl:with-param name="label">密码：</xsl:with-param>
				<xsl:with-param name="size">30</xsl:with-param>
			</xsl:apply-templates>
			<xsl:apply-templates select="rePassword" mode="form.secret">
				<xsl:with-param name="label">重复：</xsl:with-param>
				<xsl:with-param name="size">30</xsl:with-param>
			</xsl:apply-templates>
			<xsl:apply-templates select="secQuestion" mode="form.text">
				<xsl:with-param name="label">密码提示问题：</xsl:with-param>
				<xsl:with-param name="size">60</xsl:with-param>
			</xsl:apply-templates>
			<xsl:apply-templates select="secAnswer" mode="form.text">
				<xsl:with-param name="label">密码提示答案：</xsl:with-param>
				<xsl:with-param name="size">60</xsl:with-param>
			</xsl:apply-templates>
		</fieldset>
	</xsl:template>

</xsl:stylesheet>
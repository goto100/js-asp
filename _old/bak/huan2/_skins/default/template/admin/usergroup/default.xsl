<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../../common.xsl" />
	<xsl:import href="../../common/templates/adminPanel.xsl" />

	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="userGroups">
				<xsl:apply-templates select="." mode="default">
					<xsl:with-param name="title">用户组</xsl:with-param>
					<xsl:with-param name="sidebar"><xsl:call-template name="adminPanel" /></xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>

			<xsl:when test="add">
				<xsl:apply-templates select="." mode="default">
					<xsl:with-param name="title">添加用户组</xsl:with-param>
					<xsl:with-param name="sidebar"><xsl:call-template name="adminPanel" /></xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>

			<xsl:when test="edit">
				<xsl:apply-templates select="." mode="default">
					<xsl:with-param name="title">编辑用户组</xsl:with-param>
					<xsl:with-param name="sidebar"><xsl:call-template name="adminPanel" /></xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>

			<xsl:otherwise><xsl:apply-imports /></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="/userGroups">
		<xsl:apply-templates select="." mode="listTable">
			<xsl:with-param name="colCount">4</xsl:with-param>
			<xsl:with-param name="head">
				<tr>
					<th scope="col">名称</th>
					<th scope="col">用户数</th>
					<th scope="col">编辑</th>
					<th scope="col">删除</th>
				</tr>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="/userGroups/item">
		<xsl:element name="tr" use-attribute-sets="listTable.row">
			<th scope="row"><xsl:value-of select="name" /></th>
			<td><xsl:value-of select="userCount" /></td>
			<td><a href="?edit&amp;id={@id}">编辑</a></td>
			<td>
				<xsl:if test="@id != 1 and @id != 2 and @id != 3"><a href="?delete&amp;id={@id}">删除</a></xsl:if>
			</td>
		</xsl:element>
	</xsl:template>

	<xsl:template match="/add | /edit">
		<xsl:apply-templates select="." mode="form">
			<xsl:with-param name="content">
				<xsl:apply-templates select="userGroup" />
				<xsl:apply-templates select="." mode="form.submit" />
				<xsl:apply-templates select="." mode="form.reset" />
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="/add/userGroup | edit/userGroup">
		<fieldset>
			<legend>基本信息</legend>
			<xsl:apply-templates select="id" mode="form.hidden" />
			<xsl:apply-templates select="name" mode="form.text">
				<xsl:with-param name="label">名称：</xsl:with-param>
				<xsl:with-param name="size">50</xsl:with-param>
			</xsl:apply-templates>
			<xsl:apply-templates select="rightFrom" mode="form.select1">
				<xsl:with-param name="label">权限复制于：</xsl:with-param>
				<xsl:with-param name="items"><xsl:apply-templates select="../userGroups/userGroup" /></xsl:with-param>
			</xsl:apply-templates>
		</fieldset>
		<fieldset>
			<legend>组权限<em>（本组自定义权限的用户不会改变其权限设置）</em></legend>
			<xsl:apply-templates select="." mode="form.checkbox">
				<xsl:with-param name="label">
					<xsl:choose>
						<xsl:when test="name() = 'viewSite'">访问网站</xsl:when>
						<xsl:when test="name() = 'administer'">管理员</xsl:when>
						<xsl:when test="name() = 'viewMembers'">查看用户信息</xsl:when>
						<xsl:when test="name() = 'viewUsers'">查看在线用户</xsl:when>
					</xsl:choose>
				</xsl:with-param>
			</xsl:apply-templates>
		</fieldset>
	</xsl:template>

	<xsl:template match="/add/userGroups/userGroup">
		<xsl:apply-templates select="." mode="form.option">
			<xsl:with-param name="label" select="name" />
			<xsl:with-param name="value" select="@id" />
			<xsl:with-param name="selectedValue" select="../../member/rightFrom" />
		</xsl:apply-templates>
	</xsl:template>

</xsl:stylesheet>
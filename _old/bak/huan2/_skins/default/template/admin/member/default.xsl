<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../../common.xsl" />
	<xsl:import href="../../common/templates/adminPanel.xsl" />

	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="members">
				<xsl:apply-templates select="." mode="default">
					<xsl:with-param name="title">用户列表
						<xsl:if test="members/@keys"> - <xsl:value-of select="members/@keys" /></xsl:if>
					</xsl:with-param>
					<xsl:with-param name="sidebar">
						<xsl:call-template name="adminPanel" />
						<xsl:apply-templates select="/members/order" mode="orderPanel" />
						<div class="panel">
							<h2>搜索用户</h2>
							<form action=".">
								<input type="text" name="keys" value="{members/@keys}" size="12" />
								<input type="submit" value="查询" class="submit" />
							</form>
						</div>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>

			<xsl:when test="add">
				<xsl:apply-templates select="." mode="default">
					<xsl:with-param name="title">添加用户</xsl:with-param>
					<xsl:with-param name="sidebar"><xsl:call-template name="adminPanel" /></xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>

			<xsl:when test="edit">
				<xsl:apply-templates select="." mode="default">
					<xsl:with-param name="title">编辑用户</xsl:with-param>
					<xsl:with-param name="sidebar"><xsl:call-template name="adminPanel" /></xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>

			<xsl:otherwise><xsl:apply-imports /></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="/members">
		<xsl:apply-templates select="." mode="listTable">
			<xsl:with-param name="colCount">7</xsl:with-param>
			<xsl:with-param name="emptyMsg">暂时没有用户！</xsl:with-param>
			<xsl:with-param name="head">
				<tr>
					<th scope="col">Email</th>
					<th scope="col">昵称</th>
					<th scope="col">注册时间</th>
					<th scope="col">最后访问时间</th>
					<th scope="col">IP</th>
					<th scope="col">编辑</th>
					<th scope="col">删除</th>
				</tr>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="/members/order/userId">用户名</xsl:template>
	<xsl:template match="/members/order/regTime">注册时间</xsl:template>
	<xsl:template match="/members/order/nickname">昵称</xsl:template>
	<xsl:template match="/members/order/lastVisitTime">最后访问时间</xsl:template>

	<xsl:template match="/members/item">
		<xsl:element name="tr" use-attribute-sets="listTable.row">
			<th scope="row"><a href="?id={@id}"><xsl:value-of select="userId" /></a></th>
			<td><xsl:value-of select="nickname" /></td>
			<td><xsl:value-of select="regTime" /></td>
			<td><xsl:value-of select="lastVisitTime" /></td>
			<td><xsl:value-of select="lastIP" /></td>
			<td><a href="?edit&amp;id={@id}">编辑</a></td>
			<td><a href="?delete&amp;id={@id}">删除</a></td>
		</xsl:element>
	</xsl:template>

	<xsl:template match="/add | /edit">
		<xsl:apply-templates select="." mode="form">
			<xsl:with-param name="content">
				<xsl:apply-templates select="member" />
				<xsl:apply-templates select="." mode="form.submit" />
				<xsl:apply-templates select="." mode="form.reset" />
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="/add/member | /edit/member">
		<fieldset>
			<legend>基本信息</legend>
			<xsl:apply-templates select="id" mode="form.hidden" />
			<xsl:apply-templates select="userId" mode="form.text">
				<xsl:with-param name="label">ID：</xsl:with-param>
				<xsl:with-param name="size">50</xsl:with-param>
			</xsl:apply-templates>
			<xsl:apply-templates select="groupId" mode="form.select1">
				<xsl:with-param name="label">用户组：</xsl:with-param>
				<xsl:with-param name="items"><xsl:apply-templates select="../userGroups" /></xsl:with-param>
			</xsl:apply-templates>
			<xsl:apply-templates select="password" mode="form.secret">
				<xsl:with-param name="label">密码：</xsl:with-param>
				<xsl:with-param name="size">30</xsl:with-param>
			</xsl:apply-templates>
			<xsl:apply-templates select="rePassword" mode="form.secret">
				<xsl:with-param name="label">重复：</xsl:with-param>
				<xsl:with-param name="size">30</xsl:with-param>
			</xsl:apply-templates>
			<xsl:apply-templates select="nickname" mode="form.text">
				<xsl:with-param name="label">昵称：</xsl:with-param>
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

	<xsl:template match="/add/userGroups/userGroup | /edit/userGroups/userGroup">
		<xsl:apply-templates select="." mode="form.option">
			<xsl:with-param name="label" select="." />
			<xsl:with-param name="value" select="@id" />
			<xsl:with-param name="selected" select="../../../*/member/groupId = @id" />
		</xsl:apply-templates>
	</xsl:template>

</xsl:stylesheet>
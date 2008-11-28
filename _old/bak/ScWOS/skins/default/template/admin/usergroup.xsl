<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../common/default.xsl"/>
	<xsl:import href="../common/alert.xsl"/>

	<xsl:variable name="rootStr">../</xsl:variable>

	<xsl:template match="/">
		<xsl:variable name="title"><a href="usergroup.asp">用户组</a> - </xsl:variable>
		<xsl:choose>
			<xsl:when test="userGroups | add | edit | userGroup">
				<xsl:apply-templates select="." mode="default">
					<xsl:with-param name="title"><xsl:copy-of select="$title"/>
						<xsl:choose>
							<xsl:when test="userGroups">列表</xsl:when>
							<xsl:when test="add">添加</xsl:when>
							<xsl:when test="edit"><a href="?id={edit/id}"><xsl:value-of select="edit/name"/></a> - 编辑</xsl:when>
							<xsl:when test="userGroup"><xsl:value-of select="userGroup/name"/> - 查看</xsl:when>
						</xsl:choose>
					</xsl:with-param>
					<xsl:with-param name="script">admin/usergroup.js</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="addSuccess | editSuccess | deleteSuccess">
				<xsl:apply-templates select="*[@type = 'msg']" mode="success">
					<xsl:with-param name="title"><xsl:copy-of select="$title"/>
						<xsl:choose>
							<xsl:when test="addSuccess">添加成功</xsl:when>
							<xsl:when test="editSuccess">编辑成功</xsl:when>
							<xsl:when test="deleteSuccess">删除成功</xsl:when>
						</xsl:choose>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="empty | protected">
				<xsl:apply-templates select="*[@type = 'msg']" mode="error">
					<xsl:with-param name="title"><xsl:copy-of select="$title"/>
						<xsl:choose>
							<xsl:when test="empty">无此用户组</xsl:when>
							<xsl:when test="protected">删除失败</xsl:when>
						</xsl:choose>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-imports/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="/userGroups/groups">
		<h2>用户组列表</h2>
		<xsl:call-template name="listTable">
			<xsl:with-param name="cols">4</xsl:with-param>
			<xsl:with-param name="msg">暂时没有用户组。</xsl:with-param>
			<xsl:with-param name="head">
				<th scope="col">序号</th>
				<th scope="col">组名称</th>
				<th scope="col">编辑</th>
				<th scope="col">删除</th>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="/userGroups/groups/group">
			<th scope="row"><xsl:number/></th>
			<td><a href="?id={@id}"><xsl:value-of select="."/></a></td>
			<td><a href="?edit&amp;id={@id}">编辑</a></td>
			<td><a href="?delete=do&amp;id={@id}">删除</a></td>
	</xsl:template>

	<xsl:template match="/userGroup">
		<h2>用户 <xsl:value-of select="userGroup/name"/> 组</h2>
		<dl class="list" id="group_rights">
			<xsl:apply-templates select="userGroup/rights/*"/>
		</dl>
	</xsl:template>

	<xsl:template match="/add | /edit">
		<xsl:choose>
			<xsl:when test="/add">
				<h2>添加用户组</h2>
			</xsl:when>
			<xsl:when test="/edit">
				<h2>编辑用户组</h2>
			</xsl:when>
		</xsl:choose>
		<xsl:call-template name="form">
			<xsl:with-param name="content">
				<fieldset>
					<legend>基本项</legend>
					<xsl:for-each select="id | name">
						<xsl:call-template name="formItem">
							<xsl:with-param name="content">
								<xsl:apply-templates select="."/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>
				</fieldset>
				<fieldset>
					<legend>权限设置</legend>
					<xsl:for-each select="right_view | right_test">
						<xsl:call-template name="formItem">
							<xsl:with-param name="content">
								<xsl:apply-templates select="."/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>
				</fieldset>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:if test="id != '1' and id != '2' and id != '3'">
			<p><a href="?delete=do&amp;id={id}">删除此用户组</a></p>
		</xsl:if>
	</xsl:template>

	<xsl:template match="/edit/id">
		<input type="hidden" name="id" value="{.}"/>
	</xsl:template>

	<xsl:template match="/add/name | /edit/name">
		<label for="form_{name()}">名称</label>
		<input type="text" id="form_{name()}" name="{name()}" value="{.}"/>
	</xsl:template>

	<xsl:template match="/add/right_view | /edit/right_view">
		<label for="form_{name()}">浏览网站</label>
		<input type="checkbox" id="form_{name()}" name="{name()}" value="true">
			<xsl:if test=". = 'true'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
		</input>
	</xsl:template>

	<xsl:template match="/add/right_test | /edit/right_test">
		<label for="form_{name()}">测试</label>
		<input type="checkbox" id="form_{name()}" name="{name()}" value="true">
			<xsl:if test=". = 'true'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
		</input>
	</xsl:template>

</xsl:stylesheet>

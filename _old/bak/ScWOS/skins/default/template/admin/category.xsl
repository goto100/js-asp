<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../common/default.xsl"/>
	<xsl:import href="../common/alert.xsl"/>

	<xsl:variable name="rootStr">../</xsl:variable>

	<xsl:template match="/">
		<xsl:variable name="title"><a href="category.asp">分类</a> - </xsl:variable>
		<xsl:choose>
			<xsl:when test="categories | category | add | edit">
				<xsl:apply-templates select="." mode="default">
					<xsl:with-param name="title"><xsl:copy-of select="$title"/>
						<xsl:choose>
							<xsl:when test="categories">列表</xsl:when>
							<xsl:when test="category"><xsl:value-of select="/category/name"/> - 显示</xsl:when>
							<xsl:when test="add">添加</xsl:when>
							<xsl:when test="edit"><a href="?id={edit/id}"><xsl:value-of select="edit/name"/></a> - 编辑</xsl:when>
						</xsl:choose>
					</xsl:with-param>
					<xsl:with-param name="script">admin/category.js</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="addSuccess | editSuccess | deleteSuccess">
				<xsl:apply-templates select="*" mode="success">
					<xsl:with-param name="title">
						<xsl:choose>
							<xsl:when test="addSuccess">添加成功</xsl:when>
							<xsl:when test="editSuccess">编辑成功</xsl:when>
							<xsl:when test="deleteSuccess">删除成功</xsl:when>
						</xsl:choose>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="empty | haveChilds">
				<xsl:apply-templates select="*[@type = 'msg']" mode="error">
					<xsl:with-param name="title"><xsl:copy-of select="$title"/>
						<xsl:choose>
							<xsl:when test="empty">无此分类</xsl:when>
							<xsl:when test="haveChilds">无法删除</xsl:when>
						</xsl:choose>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-imports/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="/categories">
		<h2>分类列表</h2>
		<xsl:call-template name="listTable">
			<xsl:with-param name="cols">5</xsl:with-param>
			<xsl:with-param name="msg">暂时没有分类。</xsl:with-param>
			<xsl:with-param name="head">
				<th scope="col">序号</th>
				<th scope="col">名称</th>
				<th scope="col">描述</th>
				<th scope="col">编辑</th>
				<th scope="col">删除</th>
			</xsl:with-param>
			<xsl:with-param name="body">
				<xsl:apply-templates select="category[@parentId = 0]"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="/categories/category">
		<xsl:param name="id" select="@id"/>
		<tr>
			<th scope="row"><xsl:number/></th>
			<td>
				<xsl:value-of select="name"/>
			</td>
			<td><xsl:value-of select="description"/></td>
			<td><a href="?edit&amp;id={@id}" class="edit">编辑</a></td>
			<td><a href="?delete=do&amp;id={@id}" class="delete">删除</a></td>
		</tr>
		<xsl:if test="/categories/category[@parentId = $id]">
			<tr>
				<td colspan="5">
					<table class="list">
						<xsl:apply-templates select="/categories/category[@parentId = $id]"/>
					</table>
				</td>
			</tr>
		</xsl:if>
	</xsl:template>

	<xsl:template match="/add">
		<h2>请填写表单</h2>
		<xsl:call-template name="form">
			<xsl:with-param name="content">
				<fieldset>
					<legend>添加分类</legend>
					<input type="hidden" name="id" value="{id}"/>
					<xsl:for-each select="name | parentId | description | intro | link">
						<xsl:call-template name="formItem">
							<xsl:with-param name="title">
								<xsl:choose>
									<xsl:when test="name() = 'name'">名称</xsl:when>
									<xsl:when test="name() = 'parentId'">所属分类</xsl:when>
									<xsl:when test="name() = 'description'">描述</xsl:when>
									<xsl:when test="name() = 'intro'">介绍</xsl:when>
									<xsl:when test="name() = 'link'">外部链接</xsl:when>
								</xsl:choose>
							</xsl:with-param>
							<xsl:with-param name="type">
								<xsl:choose>
									<xsl:when test="name() = 'intro'">textarea</xsl:when>
									<xsl:when test="name() = 'parentId'">select</xsl:when>
									<xsl:otherwise>text</xsl:otherwise>
								</xsl:choose>
							</xsl:with-param>
							<xsl:with-param name="tabindex">
								<xsl:choose>
									<xsl:when test="name() = 'name'">1</xsl:when>
									<xsl:when test="name() = 'description'">2</xsl:when>
									<xsl:when test="name() = 'intro'">3</xsl:when>
									<xsl:when test="name() = 'link'">4</xsl:when>
								</xsl:choose>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>
				</fieldset>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="/edit">
		<h2>请填写表单</h2>
		<xsl:call-template name="form">
			<xsl:with-param name="content">
				<fieldset>
					<legend>编辑分类</legend>
					<input type="hidden" name="id" value="{id}"/>
					<xsl:for-each select="name | description | intro | link">
						<xsl:call-template name="formItem">
							<xsl:with-param name="title">
								<xsl:choose>
									<xsl:when test="name() = 'name'">名称</xsl:when>
									<xsl:when test="name() = 'description'">描述</xsl:when>
									<xsl:when test="name() = 'intro'">介绍</xsl:when>
									<xsl:when test="name() = 'link'">外部链接</xsl:when>
								</xsl:choose>
							</xsl:with-param>
							<xsl:with-param name="type">
								<xsl:choose>
									<xsl:when test="name() = 'intro'">textarea</xsl:when>
									<xsl:otherwise>text</xsl:otherwise>
								</xsl:choose>
							</xsl:with-param>
							<xsl:with-param name="tabindex">
								<xsl:choose>
									<xsl:when test="name() = 'name'">1</xsl:when>
									<xsl:when test="name() = 'description'">2</xsl:when>
									<xsl:when test="name() = 'intro'">3</xsl:when>
									<xsl:when test="name() = 'link'">4</xsl:when>
								</xsl:choose>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>
				</fieldset>
			</xsl:with-param>
		</xsl:call-template>
		<p><a href="?delete=do&amp;id={id}">删除此分类</a></p>
		<p><a href="?add&amp;pid={id}">添加分类</a></p>
	</xsl:template>

</xsl:stylesheet>

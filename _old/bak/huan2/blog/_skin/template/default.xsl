<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="common.xsl" />

	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="articles">
				<xsl:apply-templates select="." mode="default">
					<xsl:with-param name="title">列表</xsl:with-param>
					<xsl:with-param name="sidebar">
						<xsl:apply-templates select="/articles/order" mode="orderPanel" />
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>

			<xsl:when test="article">
				<xsl:apply-templates select="." mode="default">
					<xsl:with-param name="title"><xsl:value-of select="article/title" /></xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>

			<xsl:when test="add">
				<xsl:apply-templates select="." mode="default">
					<xsl:with-param name="title">发布</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>

			<xsl:when test="edit">
				<xsl:apply-templates select="." mode="default">
					<xsl:with-param name="title">编辑</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>

			<xsl:otherwise><xsl:apply-imports /></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="/articles">
		<xsl:apply-templates select="." mode="listTable">
			<xsl:with-param name="colCount">5</xsl:with-param>
			<xsl:with-param name="emptyMsg">暂时没有文章！</xsl:with-param>
			<xsl:with-param name="head">
				<tr>
					<th scope="col">标题</th>
					<th scope="col">分类</th>
					<th scope="col">发布时间</th>
					<th scope="col">编辑</th>
					<th scope="col">删除</th>
				</tr>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="/articles/order/postTime">发表时间</xsl:template>
	<xsl:template match="/articles/order/title">标题</xsl:template>
	<xsl:template match="/articles/order/category">分类</xsl:template>

	<xsl:template match="/articles/item">
		<xsl:element name="tr" use-attribute-sets="listTable.row">
			<th scope="row"><a href="?id={@id}"><xsl:value-of select="title" /></a></th>
			<td><a href="?cateId={category/@id}"><xsl:value-of select="category" /></a></td>
			<td><xsl:value-of select="postTime" /></td>
			<td><a href="?edit&amp;id={@id}">编辑</a></td>
			<td><a href="?delete&amp;id={@id}">删除</a></td>
		</xsl:element>
	</xsl:template>

	<xsl:template match="/article">
		<xsl:apply-templates select="content" mode="article" />
	</xsl:template>

	<xsl:template match="*" mode="article">
		<xsl:apply-templates mode="article" />
	</xsl:template>

	<xsl:template match="p" mode="article">
		<p><xsl:apply-templates mode="article" /></p>
	</xsl:template>

	<xsl:template match="strong" mode="article">
		<strong><xsl:value-of select="." /></strong>
	</xsl:template>

	<xsl:template match="br" mode="article">
		<br />
	</xsl:template>

	<xsl:template match="blockquote" mode="article">
		<blockquote><xsl:apply-templates mode="article" /></blockquote>
	</xsl:template>

	<xsl:template match="/add | /edit">
		<xsl:apply-templates select="." mode="form">
			<xsl:with-param name="content">
				<xsl:apply-templates select="article | save | update" />
				<xsl:apply-templates select="." mode="form.submit" />
				<xsl:apply-templates select="." mode="form.reset" />
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="/add/article | /edit/article">
		<fieldset>
			<legend>基本信息</legend>
			<xsl:apply-templates select="id" mode="form.hidden" />
			<xsl:apply-templates select="category/id" mode="form.select1">
				<xsl:with-param name="label">分类：</xsl:with-param>
				<xsl:with-param name="items">
					<xsl:apply-templates select="../category/category" />
				</xsl:with-param>
			</xsl:apply-templates>
			<xsl:apply-templates select="title" mode="form.text">
				<xsl:with-param name="label">标题：</xsl:with-param>
				<xsl:with-param name="size">60</xsl:with-param>
			</xsl:apply-templates>
			<xsl:apply-templates select="postTime" mode="form.text">
				<xsl:with-param name="label">发布时间：</xsl:with-param>
				<xsl:with-param name="size">20</xsl:with-param>
			</xsl:apply-templates>
			<xsl:apply-templates select="content" mode="form.textarea">
				<xsl:with-param name="label">内容：</xsl:with-param>
				<xsl:with-param name="cols" select="76" />
				<xsl:with-param name="rows" select="10" />
			</xsl:apply-templates>
		</fieldset>
	</xsl:template>

	<xsl:template match="/add/category//category | /edit/category//category">
		<xsl:param name="prefix"> </xsl:param>

		<xsl:apply-templates select="." mode="form.option">
			<xsl:with-param name="label" select="concat($prefix, ' ', name)" />
			<xsl:with-param name="value" select="@id" />
			<xsl:with-param name="selected" select="/*/article/cateId = @id" />
		</xsl:apply-templates>
		<xsl:if test="category">
			<xsl:apply-templates>
				<xsl:with-param name="prefix" select="concat($prefix, '-')" />
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsl:template match="/add/save">
		<fieldset>
			<legend>发布选项</legend>
			<xsl:apply-templates select="savedAction" mode="form.select1">
				<xsl:with-param name="appearance">full</xsl:with-param>
				<xsl:with-param name="label">添加后：</xsl:with-param>
				<xsl:with-param name="items">
					<xsl:apply-templates mode="form.radio">
						<xsl:with-param name="label">显示文章</xsl:with-param>
						<xsl:with-param name="value">showArticle</xsl:with-param>
					</xsl:apply-templates>
					<xsl:apply-templates mode="form.radio">
						<xsl:with-param name="label">编辑文章</xsl:with-param>
						<xsl:with-param name="value">editArticle</xsl:with-param>
					</xsl:apply-templates>
					<xsl:apply-templates mode="form.radio">
						<xsl:with-param name="label">继续添加</xsl:with-param>
						<xsl:with-param name="value">continueAdd</xsl:with-param>
					</xsl:apply-templates>
					<xsl:apply-templates mode="form.radio">
						<xsl:with-param name="label">返回列表</xsl:with-param>
						<xsl:with-param name="value">list</xsl:with-param>
					</xsl:apply-templates>
				</xsl:with-param>
			</xsl:apply-templates>
		</fieldset>
	</xsl:template>

	<xsl:template match="/edit/update">
		<fieldset>
			<legend>编辑选项</legend>
			<xsl:apply-templates select="update/action" mode="form.select1">
				<xsl:with-param name="appearance">full</xsl:with-param>
				<xsl:with-param name="label">编辑后：</xsl:with-param>
				<xsl:with-param name="items">
					<xsl:apply-templates mode="form.radio">
						<xsl:with-param name="label">显示文章</xsl:with-param>
						<xsl:with-param name="value">showArticle</xsl:with-param>
					</xsl:apply-templates>
					<xsl:apply-templates mode="form.radio">
						<xsl:with-param name="label">继续编辑</xsl:with-param>
						<xsl:with-param name="value">continueEdit</xsl:with-param>
					</xsl:apply-templates>
					<xsl:apply-templates mode="form.radio">
						<xsl:with-param name="label">返回列表</xsl:with-param>
						<xsl:with-param name="value">list</xsl:with-param>
					</xsl:apply-templates>
				</xsl:with-param>
			</xsl:apply-templates>
		</fieldset>
	</xsl:template>

</xsl:stylesheet>
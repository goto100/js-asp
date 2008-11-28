<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../common/default.xsl"/>
	<xsl:import href="../common/alert.xsl"/>

	<xsl:variable name="rootStr">
		<xsl:choose>
			<xsl:when test="/*/@rootStr"><xsl:value-of select="/*/@rootStr"/></xsl:when>
			<xsl:otherwise>../</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:template match="/">
		<xsl:variable name="title"><a href="article.asp">文章</a> - </xsl:variable>
		<xsl:choose>
			<xsl:when test="add | edit | article">
				<xsl:apply-templates select="." mode="default">
					<xsl:with-param name="title"><xsl:copy-of select="$title"/>
						<xsl:choose>
							<xsl:when test="add">添加</xsl:when>
							<xsl:when test="edit">编辑</xsl:when>
							<xsl:when test="article"><xsl:value-of select="article/title"/> - 查看</xsl:when>
						</xsl:choose>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="addSuccess | editSuccess">
				<xsl:apply-templates select="*[@type = 'msg']" mode="success">
					<xsl:with-param name="title"><xsl:copy-of select="$title"/>
						<xsl:choose>
							<xsl:when test="addSuccess">添加成功</xsl:when>
							<xsl:when test="editSuccess">编辑成功</xsl:when>
						</xsl:choose>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="empty">
				<xsl:apply-templates select="*[@type = 'msg']" mode="error">
					<xsl:with-param name="title"><xsl:copy-of select="$title"/>
						<xsl:choose>
							<xsl:when test="empty">无此文章</xsl:when>
						</xsl:choose>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-imports/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="/article">
		<h2><xsl:value-of select="title"/></h2>
		<div id="article_controlbar" class="controlbar">
			<xsl:choose>
				<xsl:when test="@previousId">
					<p class="previous"><a href="?id={@previousId}" title="{@previousTitle}">&lt;</a></p>
				</xsl:when>
				<xsl:otherwise>
					<p class="previous">&lt;</p>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="@nextId">
					<p class="next"><a href="?id={@nextId}" title="{@nextTitle}">&lt;</a></p>
				</xsl:when>
				<xsl:otherwise>
					<p class="next">&gt;</p>
				</xsl:otherwise>
			</xsl:choose>
			<a href="?edit&amp;id={@id}">编辑</a>
		</div>
		<div class="text">
			<xsl:value-of disable-output-escaping="no" select="content"/>
		</div>
	</xsl:template>

	<xsl:template match="/add | /edit">
		<h2>请填写表单</h2>
		<xsl:call-template name="form">
			<xsl:with-param name="content">
				<fieldset>
					<legend>文章内容</legend>
					<input type="hidden" name="id" value="{id}"/>
					<xsl:for-each select="title | cateId | author | from | content">
						<xsl:call-template name="formItem">
							<xsl:with-param name="type">
								<xsl:choose>
									<xsl:when test="name() = 'content'">textarea</xsl:when>
									<xsl:when test="name() = 'cateId'">select</xsl:when>
									<xsl:otherwise>text</xsl:otherwise>
								</xsl:choose>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>
				</fieldset>
				<fieldset>
					<legend>选项</legend>
					<xsl:for-each select="updateTime | updatePublisher">
						<xsl:call-template name="formItem">
							<xsl:with-param name="title">
								<xsl:choose>
									<xsl:when test="name() = 'updateTime'">更新发布人</xsl:when>
									<xsl:when test="name() = 'updatePublisher'">更新发布时间</xsl:when>
								</xsl:choose>
							</xsl:with-param>
							<xsl:with-param name="tabindex">
								<xsl:choose>
									<xsl:when test="name() = 'updateTime'">6</xsl:when>
									<xsl:when test="name() = 'updatePublisher'">7</xsl:when>
								</xsl:choose>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>
					<xsl:choose>
						<xsl:when test="/add">
							<xsl:apply-templates select="builtPath"/>
							<xsl:apply-templates select="builtName"/>
							<xsl:apply-templates select="builtType"/>
						</xsl:when>
						<xsl:when test="/edit">
							<xsl:for-each select="builtPath | builtName | builtType">
								<xsl:call-template name="formItem">
									<xsl:with-param name="title">
										<xsl:choose>
											<xsl:when test="name() = 'builtPath'">生成文件路径</xsl:when>
											<xsl:when test="name() = 'builtName'">生成文件名称</xsl:when>
											<xsl:when test="name() = 'builtType'">生成文件类型</xsl:when>
										</xsl:choose>
									</xsl:with-param>
									<xsl:with-param name="type">
										<xsl:choose>
											<xsl:when test="name() = 'builtType'">select</xsl:when>
											<xsl:otherwise>text</xsl:otherwise>
										</xsl:choose>
									</xsl:with-param>
									<xsl:with-param name="tabindex">
										<xsl:choose>
											<xsl:when test="name() = 'builtPath'">生成文件路径</xsl:when>
											<xsl:when test="name() = 'builtName'">生成文件名称</xsl:when>
											<xsl:when test="name() = 'builtType'">生成文件类型</xsl:when>
										</xsl:choose>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:for-each>
						</xsl:when>
					</xsl:choose>
				</fieldset>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="/add/builtPath">
		<div class="formItem">
			<label for="">自定义生成文件路径</label>
			<xsl:apply-templates select="../redefBPath"/>
			<xsl:call-template name="formText">
				<xsl:with-param name="id">add</xsl:with-param>
			</xsl:call-template>
			<xsl:apply-templates select="../createPath"/>
			<xsl:call-template name="formItemMsg"/>
		</div>
	</xsl:template>

	<xsl:template match="/add/createPath">
		建立路径
		<xsl:call-template name="formCheckbox">
			<xsl:with-param name="id">add</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="/add/builtName">
		<div class="formItem">
			<label for="">自定义生成文件名称</label>
			<xsl:apply-templates select="../redefBName"/>
			<xsl:call-template name="formText">
				<xsl:with-param name="id">add</xsl:with-param>
			</xsl:call-template>
			<xsl:apply-templates select="../rebuiltFile"/>
			<xsl:call-template name="formItemMsg"/>
		</div>
	</xsl:template>

	<xsl:template match="/add/rebuiltFile">
		覆盖文件
		<xsl:call-template name="formCheckbox">
			<xsl:with-param name="id">add</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="/add/builtType">
		<div class="formItem">
			<label for="">自定义生成文件类型</label>
			<xsl:apply-templates select="../redefBType"/>
			<xsl:call-template name="formSelect">
				<xsl:with-param name="id">add</xsl:with-param>
			</xsl:call-template>
			<xsl:call-template name="formItemMsg"/>
		</div>
	</xsl:template>

	<xsl:template match="/add/redefBPath | /add/redefBName | /add/redefBType">
		<xsl:call-template name="formCheckbox">
			<xsl:with-param name="id">add</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

</xsl:stylesheet>

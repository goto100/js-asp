<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../common/default.xsl"/>
	<xsl:import href="../common/alert.xsl"/>

	<xsl:variable name="rootStr">../</xsl:variable>

	<xsl:template match="/">
		<xsl:variable name="title"><a href="member.asp">成员</a> - </xsl:variable>
		<xsl:choose>
			<xsl:when test="members | edit | member">
				<xsl:apply-templates select="." mode="default">
					<xsl:with-param name="title"><xsl:copy-of select="$title"/>
						<xsl:choose>
							<xsl:when test="members">列表</xsl:when>
							<xsl:when test="edit"><a href="?id={edit/id}"><xsl:value-of select="edit/nickname"/></a> - 编辑</xsl:when>
							<xsl:when test="member"><xsl:value-of select="member/nickname"/> - 查看</xsl:when>
						</xsl:choose>
					</xsl:with-param>
					<xsl:with-param name="script">admin/member.js</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="editSuccess | deleteSuccess">
				<xsl:apply-templates select="*[@type = 'msg']" mode="success">
					<xsl:with-param name="title"><xsl:copy-of select="$title"/>
						<xsl:choose>
							<xsl:when test="editSuccess">编辑成功</xsl:when>
							<xsl:when test="deleteSuccess">删除成功</xsl:when>
						</xsl:choose>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="empty">
				<xsl:apply-templates select="*[@type = 'msg']" mode="error">
					<xsl:with-param name="title"><xsl:copy-of select="$title"/>
						<xsl:choose>
							<xsl:when test="noMember">无此成员</xsl:when>
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
			<xsl:with-param name="cols">7</xsl:with-param>
			<xsl:with-param name="msg">暂时没有用户。</xsl:with-param>
			<xsl:with-param name="head">
				<th scope="col">序号</th>
				<th scope="col">E'mail</th>
				<th scope="col">所属组</th>
				<th scope="col">昵称</th>
				<th scope="col">性别</th>
				<th scope="col">编辑</th>
				<th scope="col">删除</th>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="/members/member">
		<th scope="row"><xsl:number/></th>
		<td><a href="mailto:{email}"><xsl:value-of select="email"/></a></td>
		<td><a href="usergroup.asp?id={group/@id}"><xsl:value-of select="group"/></a></td>
		<td><xsl:value-of select="nickname"/></td>
		<td><xsl:value-of select="gender"/></td>
		<td><a href="?edit&amp;id={@id}">编辑</a></td>
		<td><a href="?delete=do&amp;id={@id}">删除</a></td>
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

	<xsl:template match="/edit">
		<h2>编辑成员 <xsl:value-of select="nickname"/></h2>
		<xsl:call-template name="form">
			<xsl:with-param name="content">
				<input type="hidden" name="id" value="{id}"/>
				<fieldset>
					<legend>修改密码</legend>
					<xsl:apply-templates select="password"/>
				</fieldset>
				<fieldset>
					<legend>帐号信息</legend>
					<xsl:for-each select="nickname | groupId | firstName | lastName | gender">
						<xsl:call-template name="formItem">
							<xsl:with-param name="title">
								<xsl:choose>
									<xsl:when test="name() = 'nickname'">昵称</xsl:when>
									<xsl:when test="name() = 'groupId'">用户组</xsl:when>
									<xsl:when test="name() = 'firstName'">姓</xsl:when>
									<xsl:when test="name() = 'lastName'">名</xsl:when>
									<xsl:when test="name() = 'gender'">性别</xsl:when>
								</xsl:choose>
							</xsl:with-param>
							<xsl:with-param name="type">
								<xsl:choose>
									<xsl:when test="name() = 'groupId'">select</xsl:when>
									<xsl:when test="name() = 'gender'">select</xsl:when>
									<xsl:otherwise>text</xsl:otherwise>
								</xsl:choose>
							</xsl:with-param>
							<xsl:with-param name="tabindex">
								<xsl:choose>
									<xsl:when test="name() = 'nickname'">2</xsl:when>
									<xsl:when test="name() = 'groupId'">3</xsl:when>
									<xsl:when test="name() = 'firstName'">4</xsl:when>
									<xsl:when test="name() = 'lastName'">5</xsl:when>
									<xsl:when test="name() = 'gender'">6</xsl:when>
								</xsl:choose>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>
				</fieldset>
				<fieldset>
					<legend>找回密码所需资料</legend>
					<xsl:for-each select="secQuestion | secAnswer">
						<xsl:call-template name="formItem">
							<xsl:with-param name="title">
								<xsl:choose>
									<xsl:when test="name() = 'secQuestion'">找回密码问题</xsl:when>
									<xsl:when test="name() = 'secAnswer'">问题答案</xsl:when>
								</xsl:choose>
							</xsl:with-param>
							<xsl:with-param name="description">
								<xsl:choose>
									<xsl:when test="name() = 'secQuestion'"><p class="description"><xsl:value-of select="@minLength"/> 至 <xsl:value-of select="@maxLength"/> 个字符。</p></xsl:when>
									<xsl:when test="name() = 'secAnswer'"><p class="description"><xsl:value-of select="@minLength"/> 至 <xsl:value-of select="@maxLength"/> 个字符。</p></xsl:when>
								</xsl:choose>
							</xsl:with-param>
							<xsl:with-param name="tabindex">
								<xsl:choose>
									<xsl:when test="name() = 'secQuestion'">7</xsl:when>
									<xsl:when test="name() = 'secAnswer'">8</xsl:when>
								</xsl:choose>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>
				</fieldset>
			</xsl:with-param>
		</xsl:call-template>
		<p><a href="?delete=do&amp;id={id}">删除此成员</a></p>
	</xsl:template>

	<xsl:template match="/edit/password">
		<xsl:call-template name="formItem">
			<xsl:with-param name="title">密码</xsl:with-param>
			<xsl:with-param name="type">password</xsl:with-param>
			<xsl:with-param name="tabindex">1</xsl:with-param>
			<xsl:with-param name="description">不修改则留空，<xsl:value-of select="@minLength"/> 至 <xsl:value-of select="@maxLength"/> 个字符。</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

</xsl:stylesheet>

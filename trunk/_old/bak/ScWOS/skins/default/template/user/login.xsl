<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../common/default.xsl"/>
	<xsl:import href="../common/alert.xsl"/>

	<xsl:variable name="rootStr">../</xsl:variable>

	<xsl:template match="/">
		<xsl:variable name="title"><a href="login.asp">登陆</a> - </xsl:variable>
		<xsl:choose>
			<xsl:when test="form">
				<xsl:apply-templates select="." mode="default">
					<xsl:with-param name="title"><xsl:copy-of select="$title"/>填写表单</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="loginSuccess | logoutSuccess">
				<xsl:apply-templates select="*[@type = 'msg']" mode="success">
					<xsl:with-param name="title">
						<xsl:choose>
							<xsl:when test="loginSuccess"><xsl:copy-of select="$title"/>成功</xsl:when>
							<xsl:when test="logoutSuccess">登出 - 成功</xsl:when>
						</xsl:choose>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="loggedIn">
				<xsl:apply-templates select="*[@type = 'msg']" mode="error">
					<xsl:with-param name="title"><xsl:copy-of select="$title"/>失败</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-imports/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="/form">
		<h2>请填写您的E'mail和密码</h2>
		<xsl:call-template name="form">
			<xsl:with-param name="content">
				<fieldset>
					<legend>基本项</legend>
					<xsl:for-each select="email | password | remState">
						<xsl:call-template name="formItem">
							<xsl:with-param name="content">
								<xsl:apply-templates select="."/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>
				</fieldset>

				<xsl:if test="@secCode='true'">
					<fieldset>
						<legend>确认登陆</legend>
						<xsl:apply-templates select="secCode"/>
					</fieldset>
				</xsl:if>
			</xsl:with-param>
		</xsl:call-template>
		<p><a href="member.asp?getpassword">找回密码</a></p>
		<p><a href="register.asp">注册</a></p>
	</xsl:template>

	<xsl:template match="/form/email">
		<label for="form_{name()}">E'mail</label>
		<input type="text" name="{name()}" id="form_{name()}" maxlength="{@maxLength}" value="{.}" tabindex="1"/>
	</xsl:template>

	<xsl:template match="/form/password">
		<label for="form_{name()}">密码</label>
		<input type="password" name="{name()}" id="form_{name()}" tabindex="2"/>
	</xsl:template>

	<xsl:template match="/form/remState">
		<label for="form_{name()}">下次登陆记住密码</label>
		<input type="checkbox" name="{name()}" id="form_{name()}" tabindex="3"/>
	</xsl:template>

	<xsl:template match="/form/secCode">
		<xsl:call-template name="formSecCode"/>
	</xsl:template>

</xsl:stylesheet>

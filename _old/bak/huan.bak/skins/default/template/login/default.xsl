<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../common.xsl" />

	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="login">
				<xsl:apply-templates select="." mode="default">
					<xsl:with-param name="title">登录</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>

			<xsl:when test="alreadyLoggedIn">
				<xsl:apply-templates select="." mode="alert">
					<xsl:with-param name="title">您已登录</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>

			<xsl:when test="loggedIn">
				<xsl:apply-templates select="." mode="alert">
					<xsl:with-param name="title">登录成功</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>

			<xsl:otherwise><xsl:apply-imports /></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="/login">
		<p class="note">还未注册？<a href="../register/">注册</a>。</p>
		<xsl:apply-templates select="." mode="form">
			<xsl:with-param name="action">.?submit</xsl:with-param>
			<xsl:with-param name="content">
				<xsl:apply-templates select="login" />
				<xsl:apply-templates select="." mode="form.submit" />
				<xsl:apply-templates select="." mode="form.reset" />
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="/login/login">
		<fieldset>
			<legend>用户信息</legend>
			<xsl:apply-templates select="userId" mode="form.text">
				<xsl:with-param name="label">Email：</xsl:with-param>
				<xsl:with-param name="size">60</xsl:with-param>
			</xsl:apply-templates>
			<xsl:apply-templates select="password" mode="form.secret">
				<xsl:with-param name="label">密码：</xsl:with-param>
				<xsl:with-param name="size">40</xsl:with-param>
			</xsl:apply-templates>
			<xsl:apply-templates select="rePassword" mode="form.secret">
				<xsl:with-param name="label">重复：</xsl:with-param>
				<xsl:with-param name="size">40</xsl:with-param>
			</xsl:apply-templates>
		</fieldset>
		<fieldset>
			<legend>登录选项</legend>
			<xsl:apply-templates select="remState" mode="form.checkbox">
				<xsl:with-param name="label">记住我的登录状态：</xsl:with-param>
			</xsl:apply-templates>
		</fieldset>
	</xsl:template>

</xsl:stylesheet>
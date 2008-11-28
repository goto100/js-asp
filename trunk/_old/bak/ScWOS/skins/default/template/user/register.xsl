<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../common/default.xsl"/>
	<xsl:import href="../common/alert.xsl"/>

	<xsl:variable name="rootStr">../</xsl:variable>

	<xsl:template match="/">
		<xsl:variable name="title"><a href="register.asp">注册</a> - </xsl:variable>
		<xsl:choose>
			<xsl:when test="agreement | form">
				<xsl:apply-templates select="." mode="default">
					<xsl:with-param name="title">
						<xsl:copy-of select="$title"/>
						<xsl:choose>
							<xsl:when test="agreement">注册协议</xsl:when>
							<xsl:when test="form">填写表单</xsl:when>
						</xsl:choose>
					</xsl:with-param>
					<xsl:with-param name="script">user/register.js</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="registerSuccess">
				<xsl:apply-templates select="*[@type = 'msg']" mode="success">
					<xsl:with-param name="title"><xsl:copy-of select="$title"/>成功</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-imports/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="/agreement">
		<h2>第一步，查看注册协议</h2>
		<div class="text">
			<xsl:value-of select="."/>
		</div>
		<form method="post" action="register.asp">
			<input type="submit" name="agree" value="I Agree"/>
			<input type="submit" name="disagree" value="I Do Not Agree"/>
		</form>
	</xsl:template>

	<xsl:template match="/form">
		<h2>第二步，填写注册表单</h2>
		<p class="note">注<strong class="important">*</strong>号的为必填。已注册？<a href="login.asp">登陆</a>。</p>
		<xsl:call-template name="form">
			<xsl:with-param name="content">
				<fieldset>
					<legend>建立您的帐号</legend>
					<xsl:for-each select="email | password">
						<xsl:call-template name="formItem">
							<xsl:with-param name="content">
								<xsl:apply-templates select="."/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>
					<xsl:call-template name="formItem">
						<xsl:with-param name="content">
							<xsl:call-template name="form_rePassword"/>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="formItem">
						<xsl:with-param name="content">
							<xsl:apply-templates select="nickname"/>
						</xsl:with-param>
					</xsl:call-template>
				</fieldset>
				<fieldset>
					<legend>找回密码所需资料</legend>
					<xsl:for-each select="secQuestion | secAnswer">
						<xsl:call-template name="formItem">
							<xsl:with-param name="content">
								<xsl:apply-templates select="."/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>
				</fieldset>
				<fieldset>
					<legend>账号信息</legend>
					<xsl:for-each select="firstName | lastName | gender">
						<xsl:call-template name="formItem">
							<xsl:with-param name="content">
								<xsl:apply-templates select="."/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>
				</fieldset>
				<xsl:if test="@secCode='true'">
					<fieldset>
						<legend>确认注册</legend>
						<xsl:apply-templates select="secCode"/>
					</fieldset>
				</xsl:if>
			</xsl:with-param>
		</xsl:call-template>
		<p><a href="?agreement">查看注册协议</a></p>
	</xsl:template>

	<xsl:template match="/form/email">
		<label for="form_{name()}"><strong class="important">*</strong>E'mail</label>
		<input type="text" name="{name()}" id="form_{name()}" maxlength="{@maxLength}" size="24" tabindex="1" value="{.}"/>
	</xsl:template>

	<xsl:template match="/form/password">
		<label for="form_{name()}"><strong class="important">*</strong>密码</label>
		<input type="password" name="{name()}" id="form_{name()}" maxlength="{@maxLength}" tabindex="2"/>
		<p class="description"><xsl:value-of select="@minLength"/> 至 <xsl:value-of select="@maxLength"/> 个字符，区分大小写。</p>
	</xsl:template>

	<xsl:template name="form_rePassword">
		<label for="form_rePassword"><strong class="important">*</strong>确认密码</label>
		<input type="password" name="rePassword" id="form_rePassword" maxlength="{/form/password/@maxLength}" tabindex="3"/>
	</xsl:template>

	<xsl:template match="/form/nickname">
		<label for="form_{name()}"><strong class="important">*</strong>昵称</label>
		<input type="text" name="{name()}" id="form_{name()}" tabindex="4" value="{.}"/>
	</xsl:template>

	<xsl:template match="/form/secQuestion">
		<label for="form_{name()}"><strong class="important">*</strong>找回密码问题</label>
		<input type="text" name="{name()}" id="form_{name()}" maxlength="{@maxLength}" tabindex="5" value="{.}"/>
		<p class="description"><xsl:value-of select="@minLength"/> 至 <xsl:value-of select="@maxLength"/> 个字符。</p>
	</xsl:template>

	<xsl:template match="/form/secAnswer">
		<label for="form_{name()}"><strong class="important">*</strong>问题答案</label>
		<input type="text" name="{name()}" id="form_{name()}" maxlength="{@maxLength}" tabindex="6" value="{.}"/>
		<p class="description"><xsl:value-of select="@minLength"/> 至 <xsl:value-of select="@maxLength"/> 个字符。</p>
	</xsl:template>

	<xsl:template match="/form/firstName">
		<label for="form_{name()}">姓</label>
		<input type="text" name="{name()}" id="form_{name()}" tabindex="7" value="{.}"/>
	</xsl:template>

	<xsl:template match="/form/lastName">
		<label for="form_{name()}">名</label>
		<input type="text" name="{name()}" id="form_{name()}" tabindex="8" value="{.}"/>
	</xsl:template>

	<xsl:template match="/form/gender">
		<label for="form_{name()}">性别</label>
		<select name="{name()}" id="form_{name()}" tabindex="9">
			<option value="0">
				<xsl:if test="gender=0"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
				保密
			</option>
			<option value="1">
				<xsl:if test="gender=1"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
				女
			</option>
			<option value="2">
				<xsl:if test="gender=2"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
				男
			</option>
		</select>
	</xsl:template>

	<xsl:template match="/form/secCode">
		<xsl:call-template name="formSecCode"/>
	</xsl:template>

</xsl:stylesheet>

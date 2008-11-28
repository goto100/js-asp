<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../../common.xsl" />

	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="edit">
				<xsl:apply-templates select="." mode="default">
					<xsl:with-param name="title">编辑个人资料</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>

			<xsl:otherwise><xsl:apply-imports /></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="/edit">
		<xsl:apply-templates select="." mode="form">
			<xsl:with-param name="content">
				<xsl:apply-templates select="member" />
				<xsl:apply-templates select="." mode="form.submit" />
				<xsl:apply-templates select="." mode="form.reset" />
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="/edit/member">
		<fieldset>
			<legend>基本信息</legend>
			<xsl:apply-templates select="userId" mode="form.text">
				<xsl:with-param name="label">Email：</xsl:with-param>
				<xsl:with-param name="size">65</xsl:with-param>
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

</xsl:stylesheet>
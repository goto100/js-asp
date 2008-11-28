<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template name="form.name">
		<xsl:for-each select="ancestor::*[count(ancestor::*) &gt; 0]">
			<xsl:value-of select="concat(name(), '.')" />
		</xsl:for-each>
		<xsl:value-of select="name()" />
	</xsl:template>

	<xsl:template match="*" mode="form">
		<xsl:param name="method">post</xsl:param>
		<xsl:param name="action">
			<xsl:choose>
				<xsl:when test="name() = 'add'">.?save</xsl:when>
				<xsl:when test="name() = 'edit'">.?update</xsl:when>
			</xsl:choose>
		</xsl:param>
		<xsl:param name="content" />
		<xsl:param name="backLink">.</xsl:param>

		<form method="{$method}" action="{$action}" class="default">
			<xsl:copy-of select="$content" />
		</form>

		<xsl:if test="$backLink"><p><a href="{$backLink}" class="back">返回</a></p></xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="form.hidden">
		<xsl:param name="name"><xsl:call-template name="form.name" /></xsl:param>
		<xsl:param name="value" select="." />

		<input type="hidden" name="{$name}" value="{$value}" />
	</xsl:template>

	<xsl:template match="*" mode="form.text">
		<xsl:param name="name"><xsl:call-template name="form.name" /></xsl:param>
		<xsl:param name="value" select="." />
		<xsl:param name="label" select="name()" />
		<xsl:param name="description" />
		<xsl:param name="size" />
		<xsl:param name="error" select="@error" />

		<label>
			<xsl:copy-of select="$label" />
			<xsl:if test="$description"><em><xsl:value-of select="$description" /></em></xsl:if>
			<xsl:if test="$error"><strong class="alert"><xsl:value-of select="$error" /></strong></xsl:if>
			<input type="text" name="{$name}" class="text" value="{$value}">
				<xsl:if test="$size"><xsl:attribute name="size"><xsl:value-of select="$size" /></xsl:attribute></xsl:if>
			</input>
		</label>
	</xsl:template>

	<xsl:template match="*" mode="form.textarea">
		<xsl:param name="name"><xsl:call-template name="form.name" /></xsl:param>
		<xsl:param name="value" select="." />
		<xsl:param name="label" select="name()" />
		<xsl:param name="cols" />
		<xsl:param name="rows" />
		<xsl:param name="error" select="@error" />

		<label>
			<xsl:copy-of select="$label" />
			<xsl:if test="$error"><strong class="alert"><xsl:value-of select="$error" /></strong></xsl:if>
			<textarea name="{$name}">
				<xsl:if test="$cols"><xsl:attribute name="cols"><xsl:value-of select="$cols" /></xsl:attribute></xsl:if>
				<xsl:if test="$rows"><xsl:attribute name="rows"><xsl:value-of select="$rows" /></xsl:attribute></xsl:if>
				<xsl:value-of select="$value" />
			</textarea>
		</label>
	</xsl:template>

	<xsl:template match="*" mode="form.secret">
		<xsl:param name="name"><xsl:call-template name="form.name" /></xsl:param>
		<xsl:param name="value" select="." />
		<xsl:param name="label" select="name()" />
		<xsl:param name="size" />
		<xsl:param name="error" select="@error" />

		<label>
			<xsl:copy-of select="$label" />
			<xsl:if test="$error"><strong class="alert"><xsl:value-of select="$error" /></strong></xsl:if>
			<input type="password" class="password" name="{$name}">
				<xsl:if test="$size"><xsl:attribute name="size"><xsl:value-of select="$size" /></xsl:attribute></xsl:if>
			</input>
		</label>
	</xsl:template>

	<xsl:template match="*" mode="form.select1">
		<xsl:param name="name"><xsl:call-template name="form.name" /></xsl:param>
		<xsl:param name="appearance">minimal</xsl:param>
		<xsl:param name="label" select="name()" />
		<xsl:param name="items" />
		<xsl:param name="error" select="@error" />

		<xsl:choose>
			<xsl:when test="$appearance = 'full'">
				<label>
					<xsl:copy-of select="$label" />
					<xsl:if test="$error"><strong class="alert"><xsl:value-of select="$error" /></strong></xsl:if>
					<xsl:copy-of select="$items" />
				</label>
			</xsl:when>
			<xsl:otherwise>
				<label>
					<xsl:copy-of select="$label" />
					<xsl:if test="$error"><strong class="alert"><xsl:value-of select="$error" /></strong></xsl:if>
					<select name="{$name}">
						<xsl:copy-of select="$items" />
					</select>
				</label>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*" mode="form.select">
		<xsl:param name="name"><xsl:call-template name="form.name" /></xsl:param>
		<xsl:param name="appearance">compact</xsl:param>
		<xsl:param name="label" select="name()" />
		<xsl:param name="items" />
		<xsl:param name="error" select="@error" />

		<xsl:choose>
			<xsl:when test="$appearance = 'compact'">
				<label>
					<xsl:copy-of select="$label" />
					<xsl:if test="$error"><strong class="alert"><xsl:value-of select="$error" /></strong></xsl:if>
					<xsl:copy-of select="$items" />
				</label>
			</xsl:when>
			<xsl:otherwise>
				<label>
					<xsl:copy-of select="$label" />
					<xsl:if test="$error"><strong class="alert"><xsl:value-of select="$error" /></strong></xsl:if>
					<select multiple="multiple" name="{$name}">
						<xsl:copy-of select="$items" />
					</select>
				</label>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*" mode="form.option">
		<xsl:param name="value" />
		<xsl:param name="label" />
		<xsl:param name="selected" />
		<xsl:param name="selectedValue" select="." />

		<option value="{$value}">
			<xsl:if test="$selected = 'true' or $selectedValue = $value"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
			<xsl:value-of select="$label" />
		</option>
	</xsl:template>

	<xsl:template match="*" mode="form.radio">
		<xsl:param name="name"><xsl:call-template name="form.name" /></xsl:param>
		<xsl:param name="label" select="name()" />
		<xsl:param name="value" select="." />
		<xsl:param name="checked" select=". = $value" />

		<label>
			<input type="radio" class="radio" name="{$name}" value="{$value}">
				<xsl:if test="$checked"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
			</input>
			<xsl:value-of select="$label" />
		</label>
	</xsl:template>

	<xsl:template match="*" mode="form.checkbox">
		<xsl:param name="name"><xsl:call-template name="form.name" /></xsl:param>
		<xsl:param name="label" />
		<xsl:param name="value" />
		<xsl:param name="checked" select="text() and . != '0'" />

		<label><xsl:value-of select="$label" />
			<input type="checkbox" class="checkbox" name="{$name}">
				<xsl:if test="$value"><xsl:attribute name="value"><xsl:value-of select="$value" /></xsl:attribute></xsl:if>
				<xsl:if test="$checked"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
			</input>
		</label>
	</xsl:template>

	<xsl:template match="*" mode="form.reset">
		<xsl:param name="label">重置</xsl:param>

		<input type="reset" value="{$label}" class="reset" />
	</xsl:template>

	<xsl:template match="*" mode="form.submit">
		<xsl:param name="label">提交</xsl:param>

		<input type="submit" value="{$label}" class="submit" />
	</xsl:template>

</xsl:stylesheet>

<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template name="adminPanel">
		<xsl:param name="adminPath">../</xsl:param>

		<div class="panel">
			<h2>管理</h2>
			<ul>
				<li><a href="{$adminPath}">系统信息</a></li>
				<li><a href="{$adminPath}setting">系统设置</a></li>
				<li><a href="{$adminPath}category">分类设置</a> | <a href="{$adminPath}category/?add">添加</a></li>
			</ul>
		</div>
	</xsl:template>

</xsl:stylesheet>
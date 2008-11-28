<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../../common.xsl" />

	<xsl:template name="messageSidebar">
		<div class="panel">
			<h2>导航</h2>
			<p><a href="?new">发送消息</a></p>
			<p><a href=".">收件箱</a></p>
			<p><a href="?sent">发件箱</a></p>
		</div>
	</xsl:template>

	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="messages">
				<xsl:apply-templates select="." mode="default">
					<xsl:with-param name="title">收件箱</xsl:with-param>
					<xsl:with-param name="sidebar">
						<xsl:call-template name="messageSidebar" />
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>

			<xsl:when test="sentMessages">
				<xsl:apply-templates select="." mode="default">
					<xsl:with-param name="title">发件箱</xsl:with-param>
					<xsl:with-param name="sidebar">
						<xsl:call-template name="messageSidebar" />
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>

			<xsl:when test="message">
				<xsl:apply-templates select="." mode="default">
					<xsl:with-param name="title"><xsl:value-of select="message/title" /></xsl:with-param>
					<xsl:with-param name="sidebar">
						<xsl:call-template name="messageSidebar" />
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>

			<xsl:when test="new">
				<xsl:apply-templates select="." mode="default">
					<xsl:with-param name="title">发送消息</xsl:with-param>
					<xsl:with-param name="sidebar">
						<xsl:call-template name="messageSidebar" />
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>

			<xsl:otherwise><xsl:apply-imports /></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="/messages">
		<xsl:apply-templates select="." mode="listTable">
			<xsl:with-param name="colCount">4</xsl:with-param>
			<xsl:with-param name="emptyMsg">没有记录！</xsl:with-param>
			<xsl:with-param name="head">
				<tr>
					<th scope="col">发送人</th>
					<th scope="col">标题</th>
					<th scope="col">发送时间</th>
					<th scope="col">删除</th>
				</tr>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="/messages/item">
		<xsl:element name="tr" use-attribute-sets="listTable.row">
			<td><a href="../../member/?id={sender/@id}"><xsl:value-of select="sender" /></a></td>
			<th scope="row"><a href="?id={@id}"><xsl:value-of select="title" /></a></th>
			<td><xsl:value-of select="sendTime" /></td>
			<td><a href="?delete&amp;id={@id}">删除</a></td>
		</xsl:element>
	</xsl:template>

	<xsl:template match="/sentMessages">
		<xsl:apply-templates select="." mode="listTable">
			<xsl:with-param name="colCount">4</xsl:with-param>
			<xsl:with-param name="emptyMsg">没有记录！</xsl:with-param>
			<xsl:with-param name="head">
				<tr>
					<th scope="col">收件人</th>
					<th scope="col">标题</th>
					<th scope="col">发送时间</th>
					<th scope="col">删除</th>
				</tr>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="/sentMessages/item">
		<xsl:element name="tr" use-attribute-sets="listTable.row">
			<td><a href="../../member/?id={reciver/@id}"><xsl:value-of select="reciver" /></a></td>
			<th scope="row"><a href="?id={@id}"><xsl:value-of select="title" /></a></th>
			<td><xsl:value-of select="sendTime" /></td>
			<td><a href="?delete&amp;id={@id}">删除</a></td>
		</xsl:element>
	</xsl:template>

	<xsl:template match="/message">
		<div class="info">
			<ul>
				<li>发件人：<a href="../../member/?id={sender/@id}"><xsl:value-of select="sender" /></a></li>
				<li>收件人：<a href="../../member/?id={reciver/@id}"><xsl:value-of select="reciver" /></a></li>
				<li>发送时间：<xsl:value-of select="sendTime" /></li>
			</ul>
		</div>
		<div class="text">
			<xsl:value-of select="content" />
		</div>
	</xsl:template>

	<xsl:template match="/new">
		<xsl:apply-templates select="." mode="form">
			<xsl:with-param name="action">?send</xsl:with-param>
			<xsl:with-param name="content">
				<xsl:apply-templates select="message | send" />
				<xsl:apply-templates select="." mode="form.submit">
					<xsl:with-param name="label">发送</xsl:with-param>
				</xsl:apply-templates>
				<xsl:apply-templates select="." mode="form.reset" />
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="/new/message">
		<fieldset>
			<legend>消息信息</legend>
			<xsl:apply-templates select="reciverUserIds" mode="form.text">
				<xsl:with-param name="label">收件人：</xsl:with-param>
				<xsl:with-param name="size">60</xsl:with-param>
			</xsl:apply-templates>
			<xsl:apply-templates select="title" mode="form.text">
				<xsl:with-param name="label">标题：</xsl:with-param>
				<xsl:with-param name="size">60</xsl:with-param>
			</xsl:apply-templates>
			<xsl:apply-templates select="content" mode="form.textarea">
				<xsl:with-param name="label">内容：</xsl:with-param>
				<xsl:with-param name="cols">60</xsl:with-param>
				<xsl:with-param name="rows">10</xsl:with-param>
			</xsl:apply-templates>
		</fieldset>
	</xsl:template>

	<xsl:template match="/new/send">
		<fieldset>
			<legend>发送信息</legend>
			<xsl:apply-templates select="save" mode="form.checkbox">
				<xsl:with-param name="label">保存至发件箱：</xsl:with-param>
			</xsl:apply-templates>
		</fieldset>
	</xsl:template>

</xsl:stylesheet>
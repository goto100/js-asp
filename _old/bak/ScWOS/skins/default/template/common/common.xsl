<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" encoding="utf-8" omit-xml-declaration="yes" doctype-public="-//W3C//XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>

	<xsl:variable name="sys.setting.siteName"><xsl:value-of select="document('../../../../config/global.xml')/config/siteName"/></xsl:variable>
	<xsl:variable name="sys.setting.defaultStyle"><xsl:value-of select="document('../../../../config/global.xml')/config/defaultStyle"/></xsl:variable>

	<xsl:template match="/">
		<xsl:apply-templates select="*[type = 'msg']" mode="error">
			<xsl:with-param name="title">
				<xsl:choose>
					<xsl:when test="noRight">权限不足</xsl:when>
					<xsl:when test="badRequest">非法请求</xsl:when>
				</xsl:choose>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>


	<xsl:template name="navbar">
		<div id="Navbar">
			<ul>
				<li><a href="{$rootStr}user/register.asp">注册</a></li>
				<li><a href="{$rootStr}user/member.asp">成员</a></li>
				<li>管理</li>
				<li><a href="{$rootStr}admin/setting.asp">设置</a></li>
				<li><a href="{$rootStr}admin/member.asp">成员</a></li>
				<li><a href="{$rootStr}admin/usergroup.asp">用户组</a></li>
				<li><a href="{$rootStr}admin/category.asp">分类</a></li>
				<li>系统</li>
				<li><a href="{$rootStr}article/article.asp">文章</a></li>
			</ul>
		</div>
	</xsl:template>

	<xsl:template name="form">
		<xsl:param name="content"/>
		<xsl:param name="resetStr">重置</xsl:param>
		<xsl:param name="submitStr">提交</xsl:param>
		<form method="{@method}" action="?{@action}">
			<xsl:copy-of select="$content"/>
			<input type="submit" value="{$submitStr}" class="submit" tabindex="99"/>
			<input type="reset" value="{$resetStr}" class="reset" tabindex="98"/>
		</form>
	</xsl:template>

	<xsl:template name="formSecCode">
		<xsl:call-template name="formItem">
			<xsl:with-param name="content">
				<label for="form_{name()}">验证码</label>
				<input type="text" name="{name()}" id="form_{name()}" maxlength="{@length}" size="{@length}" tabindex="97"/>
				<div class="secCode">
					<img src="{$rootStr}scode.asp" alt="Security Code" id="form_secCodePic"/> 看不清楚？<a href="javascript:refreshSecCodePic()">换一个</a>。
				</div>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="formItem">
		<xsl:param name="id">form</xsl:param>
		<xsl:param name="title" select="@title"/>
		<xsl:param name="type">
			<xsl:choose>
				<xsl:when test="@type = 'bool'">checkbox</xsl:when>
				<xsl:when test="values">list</xsl:when>
				<xsl:otherwise>text</xsl:otherwise>
			</xsl:choose>
		</xsl:param>
		<xsl:param name="tabindex"/>
		<xsl:param name="description"/>
		<div class="formItem">
			<label for="{$id}_{name()}"><xsl:value-of select="$title"/>：</label>
			<xsl:choose>
				<xsl:when test="$type = 'text'">
					<xsl:call-template name="formText">
						<xsl:with-param name="id" select="$id"/>
						<xsl:with-param name="tabindex" select="$tabindex"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="$type = 'password'">
					<xsl:call-template name="formPassword">
						<xsl:with-param name="id" select="$id"/>
						<xsl:with-param name="tabindex" select="$tabindex"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="$type = 'checkbox'">
					<xsl:call-template name="formCheckbox">
						<xsl:with-param name="id" select="$id"/>
						<xsl:with-param name="tabindex" select="$tabindex"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="$type = 'select'">
					<xsl:call-template name="formSelect">
						<xsl:with-param name="id" select="$id"/>
						<xsl:with-param name="tabindex" select="$tabindex"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="$type = 'textarea'">
					<xsl:call-template name="formTextarea">
						<xsl:with-param name="id" select="$id"/>
						<xsl:with-param name="tabindex" select="$tabindex"/>
					</xsl:call-template>
				</xsl:when>
			</xsl:choose>
			<xsl:call-template name="formItemMsg">
				<xsl:with-param name="description" select="$description"/>
			</xsl:call-template>
		</div>
	</xsl:template>

	<xsl:template name="formItemMsg">
		<xsl:param name="description"/>
		<xsl:if test="$description">
			<p class="description"><xsl:value-of select="$description"/></p>
		</xsl:if>
		<xsl:if test="@error">
			<p class="alert"><xsl:value-of select="@error"/></p>
		</xsl:if>
	</xsl:template>

	<xsl:template name="formText">
		<xsl:param name="id">form</xsl:param>
		<xsl:param name="tabindex"/>
		<input type="text" name="{name()}" id="{$id}_{name()}">
			<xsl:if test="."><xsl:attribute name="value"><xsl:value-of select="."/></xsl:attribute></xsl:if>
			<xsl:if test="$tabindex"><xsl:attribute name="tabindex"><xsl:value-of select="$tabindex"/></xsl:attribute></xsl:if>
		</input>
	</xsl:template>

	<xsl:template name="formPassword">
		<xsl:param name="id">form</xsl:param>
		<xsl:param name="tabindex"/>
		<input type="password" name="{name()}" id="{$id}_{name()}">
			<xsl:if test="$tabindex"><xsl:attribute name="tabindex"><xsl:value-of select="$tabindex"/></xsl:attribute></xsl:if>
		</input>
	</xsl:template>

	<xsl:template name="formCheckbox">
		<xsl:param name="id">form</xsl:param>
		<xsl:param name="tabindex"/>
		<input type="checkbox" name="{name()}" id="{$id}_{name()}" value="true">
			<xsl:if test=". = 'true'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
			<xsl:if test="$tabindex"><xsl:attribute name="tabindex"><xsl:value-of select="$tabindex"/></xsl:attribute></xsl:if>
		</input>
	</xsl:template>

	<xsl:template name="formRadio">
		<xsl:param name="id">form</xsl:param>
		<xsl:param name="tabindex"/>
		<input type="radio" name="{name()}" id="{$id}_{name()}" value="true">
			<xsl:if test=". = 'true'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
			<xsl:if test="$tabindex"><xsl:attribute name="tabindex"><xsl:value-of select="$tabindex"/></xsl:attribute></xsl:if>
		</input>
	</xsl:template>

	<xsl:template name="formSelect">
		<xsl:param name="id">form</xsl:param>
		<xsl:param name="tabindex"/>
		<xsl:variable name="value" select="./text()"/>
		<select name="{name()}" id="{$id}_{name()}">
			<xsl:if test="$tabindex"><xsl:attribute name="tabindex"><xsl:value-of select="$tabindex"/></xsl:attribute></xsl:if>
			<xsl:for-each select="values/value">
				<option value="{.}">
					<xsl:if test=". = $value">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="@title"/>
					</option>
			</xsl:for-each>
		</select>
	</xsl:template>

	<xsl:template name="formTextarea">
		<xsl:param name="id">form</xsl:param>
		<xsl:param name="tabindex"/>
		<textarea name="{name()}" id="{$id}_{name()}">
			<xsl:if test="$tabindex"><xsl:attribute name="tabindex"><xsl:value-of select="$tabindex"/></xsl:attribute></xsl:if>
			<xsl:value-of select="."/>
		</textarea>
	</xsl:template>

	<xsl:template name="listTable">
		<xsl:param name="cols"/>
		<xsl:param name="msg"/>
		<xsl:param name="head"/>
		<xsl:param name="body"/>
		<xsl:choose>
			<xsl:when test="count(*)">
				<xsl:if test="@pageCount">
					<xsl:call-template name="pagebar"/>
				</xsl:if>
				<table class="list">
					<thead>
						<xsl:copy-of select="$head"/>
					</thead>
					<tfoot>
						<td colspan="{$cols}">
							<xsl:if test="@pageSize">
								每页 <xsl:value-of select="@pageSize"/> 项
							</xsl:if>
							<xsl:choose>
								<xsl:when test="@recordCount">共 <xsl:value-of select="@recordCount"/> 项</xsl:when>
								<xsl:otherwise>共 <xsl:value-of select="count(*)"/> 项</xsl:otherwise>
							</xsl:choose>
						</td>
					</tfoot>
					<tbody>
						<xsl:choose>
							<xsl:when test="$body">
								<xsl:copy-of select="$body"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="*">
									<tr>
										<xsl:call-template name="listTableRows"/>
										<xsl:apply-templates select="."/>
									</tr>
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
					</tbody>
				</table>
			</xsl:when>
			<xsl:otherwise>
				<p class="msg"><xsl:value-of select="$msg"/></p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="listTableRows">
		<xsl:attribute name="class">
			<xsl:choose>
				<xsl:when test="position() mod(2) = 0">row1</xsl:when>
				<xsl:otherwise>row2</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>

	<xsl:template name="pagebar">
		<xsl:param name="total" select="12"/>
		<xsl:param name="left" select="5"/>
		<xsl:variable name="pageParam">
			<xsl:choose>
				<xsl:when test="/*/@pageParam"><xsl:value-of select="/*/@pageParam"/>&amp;</xsl:when>
				<xsl:otherwise></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="right" select="$total - $left"/>
		<xsl:variable name="currentPage" select="number(@currentPage)"/>
		<xsl:variable name="pageCount" select="number(@pageCount)"/>
		<xsl:variable name="count">
			<xsl:choose>
				<xsl:when test="$pageCount &lt; $total">
					<xsl:value-of select="$pageCount"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$total"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="start">
			<xsl:choose>
				<xsl:when test="$currentPage &lt; $left + 1">1</xsl:when>
				<xsl:when test="$currentPage + $right &gt; $pageCount">
					<xsl:value-of select="$pageCount - $count + 1"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$currentPage - $left"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<div id="{name()}_pagebar" class="pagebar">
			<xsl:choose>
				<xsl:when test="$currentPage &gt; 1">
					<p class="previous"><a href="?{$pageParam}p={$currentPage - 1}" title="上一页">&lt;</a></p>
				</xsl:when>
				<xsl:otherwise>
					<p class="previous">&lt;</p>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="$currentPage &lt; $pageCount">
					<p class="next"><a href="?{$pageParam}p={$currentPage + 1}" title="下一页">&gt;</a></p>
				</xsl:when>
				<xsl:otherwise>
					<p class="next">&gt;</p>
				</xsl:otherwise>
			</xsl:choose>
			<ul>
				<xsl:if test="$start &gt; 1">
					<li class="first"><a href="?{$pageParam}p=1" title="首页">&lt;&lt;</a></li>
				</xsl:if>
				<xsl:call-template name="pagebarItem">
					<xsl:with-param name="pageParam" select="$pageParam"/>
					<xsl:with-param name="total" select="$count"/>
					<xsl:with-param name="start" select="$start"/>
				</xsl:call-template>
				<xsl:if test="$start + $count &lt; $pageCount + 1">
					<li class="last"><a href="?p={$pageCount}" title="末页">&gt;&gt;</a></li>
				</xsl:if>
			</ul>
			<p class="total">共 <xsl:value-of select="@pageCount"/> 页</p>
		</div>
	</xsl:template>

	<xsl:template name="pagebarItem">
		<xsl:param name="pageParam"/>
		<xsl:param name="start" select="1"/>
		<xsl:param name="total" select="number(@pageCount)"/>
		<xsl:variable name="currentPage" select="number(@currentPage)"/>
			<xsl:if test="$total > 0">
				<xsl:choose>
					<xsl:when test="$start = $currentPage">
						<li class="current"><xsl:value-of select="$start"/></li>
					</xsl:when>
					<xsl:otherwise>
						<li class="item"><a href="?{$pageParam}p={$start}" title="第 {$start} 页"><xsl:value-of select="$start"/></a></li>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:call-template name="pagebarItem">
					<xsl:with-param name="pageParam" select="$pageParam"/>
					<xsl:with-param name="total" select="$total - 1"/>
					<xsl:with-param name="start" select="$start + 1"/>
				</xsl:call-template>
			</xsl:if>
	</xsl:template>

</xsl:stylesheet>

<!-- #include file = "common/common.asp" -->
<!-- #include file = "skins/default/templates/default.asp" -->
<!-- #include file = "source/login.asp" -->
<%
function outputLogin() {
	thePage.outputStart();
%>
<div id="login">
	<table class="form">
	<form method="post" action="?act=dologin">
		<tfoot>
			<tr>
				<td><input type="submit" value="<%=getLang("login")%>" class="submit" /></td>
				<td><input type="button" value="<%=getLang("register_new_account")%>" class="button" /></td>
			</tr>
		</tfoot>
		<tbody>
			<tr>
				<td>&nbsp;</td>
				<th scope="col"><%=getLang("input_desc")%></th>
			</tr>
			<tr>
				<th scope="row"><%=getLang("username")%></th>
				<td><input type="text" name="username" class="text" /></td>
			</tr>
			<tr>
				<th scope="row"><%=getLang("password")%></th>
				<td><input type="password" name="password" class="text" /></td>
			</tr><%if (theCache.setting.securityCode) {%>
			<tr>
				<th scope="row"><%=getLang("security_code")%> <a href="#" title="<%=getLang("security_code_desc")%>">?</a></th>
				<td><input type="text" name="scode" size="4" maxlength="4" class="text" />&nbsp;<img src="scode.asp" alt="<%=getLang("security_code")%>" /></td>
			</tr><%}%>
			<tr>
				<th scope="row"><%=getLang("cookie_option")%> <a href="#" title="<%=getLang("cookie_option_desc")%>">?</a></th>
				<td>
					<ul>
						<li><input type="radio" name="cookietime" value="0" checked="true" /><%=getLang("no_save")%></li>
						<li><input type="radio" name="cookietime" value="1" /><%=getLang("save_one_day")%></li>
						<li><input type="radio" name="cookietime" value="30" /><%=getLang("save_one_month")%></li>
						<li><input type="radio" name="cookietime" value="365" /><%=getLang("save_one_year")%></li>
					</ul>
				</td>
			</tr>
		</tbody>
		</form>
	</table>
</div>
<%
	thePage.outputEnd();
}
%>
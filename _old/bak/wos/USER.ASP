<!-- #include file = "common/common.asp" -->
<!-- #include file = "skins/default/templates/content.asp" -->
<!-- #include file = "source/user.asp" -->
<%
function outputUser(arrUser) {
	thePage.outputStart();
%>
<div id="user">
	<table>
			<tr>
				<th scope="row"><%=getLang("username")%>:</th>
				<td><%=arrUser.username%></td>
			</tr>
			<tr>
				<th scope="row"><%=getLang("user_group")%>:</th>
				<td><%=arrUser.group.name%></td>
			</tr>
			<tr>
				<th scope="row"><%=getLang("gender")%>:</th>
				<td><%=arrUser.gender%></td>
			</tr>
			<tr>
				<th scope="row"><%=getLang("email")%>:</th>
				<td><%if (arrUser.email) {%><a href="mailto:<%=arrUser.email%>"><%=arrUser.email%></a><%}%></td>
			</tr>
			<tr>
				<th scope="row"><%=getLang("website")%>:</th>
				<td><%if (arrUser.website) {%><a href="<%=arrUser.website%>"><%=arrUser.website%></a><%}%></td>
			</tr>
		</tbody>
	</table>
</div>
<%
	thePage.outputEnd();
}

function outputUsers(arrUsers, arrGroups) {
	var panel = ["<a href=\"?\">" + getLang("all") + "</a>"];
	for (var i = 0; i < arrGroups.length; i++) {
		panel.push("<a href=\"?group=" + arrGroups[i].id + "\">" + arrGroups[i].name + "</a>");
	}
	thePage.addPanel(getLang("user_group"), panel);
	thePage.outputStart();
%>
<div id="users"><%if (!arrUsers) {%>
	<p class="msg"><%=getLang("no_user_list")%></p><%} else {%>
	<table class="list">
		<thead>
			<tr>
				<th scope="col"><%=getLang("username")%></th>
				<th scope="col"><%=getLang("user_group")%></th><%if (theUser.right.manage) {%>
				<th scope="col"><%=getLang("edit")%></th><%}%>
			</tr>
		</thead>
		<tbody><%for (var i = 0; i < arrUsers.length; i++) {%>
			<tr>
				<td><a href="?id=<%=arrUsers[i].id%>"><%=arrUsers[i].name%></a></td>
				<td><%=arrUsers[i].groupName%></td><%if (theUser.right.manage) {%>
				<td><a href="?act=edit&amp;id=<%=arrUsers[i].id%>"><%=getLang("edit")%></a></td><%}%>
			</tr><%}%>
		</tbody>
	</table><%}%>
</div>
<%
	thePage.outputSidebar();
	thePage.outputEnd();
}

function outputEdit(arrUser, arrUserGroups) {
	thePage.outputStart();
%>
<div id="edit">
  <table class="form">
		<form method="post" action="?act=doedit&amp;id=<%=arrUser.id%>">
		<tfoot>
			<tr>
				<td colspan="2"><input type="submit" value="<%=getLang("submit")%>" class="submit" /></td>
			</tr>
		</tfoot>
		<tbody>
			<tr>
				<th scope="row"><%=getLang("username")%>:</th>
				<td><%=arrUser.username%></td>
			</tr><%if (theUser.right.manage) {%>
			<tr>
				<th scope="row"><%=getLang("user_group")%>:</th>
				<td>
					<select name="user_groupId">
						<option value="0"><%=getLang("select_user_group")%></option><%if (arrUserGroups) { for (var i = 0; i < arrUserGroups.length; i++) {%>
						<option value="<%=arrUserGroups[i].id%>"<%if (arrUser.group.id == arrUserGroups[i].id) {%> selected="true"<%}%>><%=arrUserGroups[i].name%></option><%} }%>
					</select>
				</td>
			</tr><%}%>
			<tr>
				<th scope="row"><%=getLang("password")%>:</th>
				<td><input type="password" name="user_password" size="15" /><strong class="important">&nbsp;*</strong></td>
			</tr>
			<tr>
				<th scope="row"><%=getLang("new_password")%>:</th>
				<td><input type="password" name="user_newPassword" size="15" /></td>
			</tr>
			<tr>
				<th scope="row"><%=getLang("confirm")%>:</th>
				<td><input type="password" name="user_confirmPassword" size="15" /></td>
			</tr>
			<tr>
				<th scope="row"><%=getLang("gender")%>:</th>
				<td>
					<input type="radio" name="user_gender"<%if (arrUser.gender == 0){%> checked="true"<%}%> value="0" />&nbsp;<%=getLang("secret")%>
					<input type="radio" name="user_gender"<%if (arrUser.gender == 1){%> checked="true"<%}%> value="1" />&nbsp;<%=getLang("man")%>
					<input type="radio" name="user_gender"<%if (arrUser.gender == 2){%> checked="true"<%}%> value="2" />&nbsp;<%=getLang("woman")%>
				</td>
			</tr>
			<tr>
				<th scope="row"><%=getLang("email")%>:</th>
				<td><input type="text" name="user_email" value="<%=arrUser.email%>" class="text" /></td>
			</tr>
			<tr>
				<th scope="row"><%=getLang("website")%>:</th>
				<td><input type="text" name="user_website" value="<%=arrUser.website%>" class="text" /></td>
			</tr>
		</tbody>
		</form>
  </table>
	<p class="note"><%if (theUser.right.manage) {%><%=getLang("manager_edit_profile_desc")%><%} else {%><%=getLang("edit_profile_desc")%></p><%}%>
</div>
<%
	thePage.outputEnd();
}
%>
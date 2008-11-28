<!-- #include file = "common/common.asp" -->
<!-- #include file = "source/usergroup.asp" -->
<%
function outputUserGroup(arrUserGroups) {
	thePage.outputStart(getLang("user_group") + " - ");
%>
<div id="userGroup">
	<%thePage.outputH2(getLang("user_group"))%>
	<table class="list">
		<form method="post" action="?act=submit">
		<thead>
			<tr>
				<th scope="col"><%=getLang("delete")%></th>
				<th scope="col"><%=getLang("name")%></th>
				<th scope="col"><%=getLang("manage_")%></th>
			</tr>
		</thead>
		<tfoot>
			<tr>
				<td colspan="2"><input type="submit" value="<%=getLang("submit")%>" class="submit" /></td>
			</tr>
		</tfoot>
		<tbody><%for (var i = 0; i < arrUserGroups.length; i++) {%>
			<tr>
				<td><input type="checkbox" name="group_delete" value="<%=arrUserGroups[i].id%>"<%if (arrUserGroups[i].id == 1 || arrUserGroups[i].id == 2 || arrUserGroups[i].id == 3) {%> disabled="true"<%}%> /><input type="hidden" name="group_id" value="<%=arrUserGroups[i].id%>" /></td>
				<td><input type="text" name="group_name" value="<%=arrUserGroups[i].name%>" class="text" /></td>
			</tr><%}%>
		</tbody>
		<tbody>
			<tr>
				<th scope="row"><%=getLang("new")%>:<input type="hidden" name="group_id" value="0" /></td>
				<td><input type="text" name="group_name" class="text" /></td>
			</tr>
		</tbody>
		</form>
	</table>
	<p class="note"><%=getLang("base_group_note_desc")%></p>
	<p class="note"><%=getLang("delete_group_note_desc")%></p>
</div>
<%
	thePage.outputSidebar();
	thePage.outputEnd();
}
%>
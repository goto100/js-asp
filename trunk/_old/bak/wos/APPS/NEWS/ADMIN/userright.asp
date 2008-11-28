<!-- #include file = "common/common.asp" -->
<!-- #include file = "source/userright.asp" -->
<%
function outputRight(arrUserGroups, arrUserRight) {
	var e = arrUserRight.getExpandoNames();
	thePage.outputStart(getLang("news_system_manage") + " - " + getLang("user_right") + " - ");
%>
<div id="right">
	<%thePage.outputH2(getLang("user_right"))%>
	<table class="form">
		<form method="post" action="../../../News/admin/?act=submit">
		<thead>
			<tr>
				<th scope="col"><%=getLang("user_group")%></th><%for (var i = 0; i < e.length; i++) {%>
				<th scope="col"><%=arrUserRight[e[i]].name%></th><%}%>
			</tr>
		</thead>
		<tfoot>
			<tr>
				<td><input type="submit" value="<%=getLang("submit")%>" class="submit" /></td>
			</tr>
		</tfoot>
		<tbody><%for (var i = 0; i < arrUserGroups.length; i++) {%>
			<tr>
				<th scope="row"><%=arrUserGroups[i].name%><input type="hidden" name="group_id" value="<%=arrUserGroups[i].id%>" /></th><%for (var j = 0; j < e.length; j++) {%>
				<td>
					<select name="group_right_<%=e[j]%>"><%for (var k = 0; k < arrUserRight[e[j]].rights.length; k++) {%>
						<option value="<%=k%>"<%if (arrUserGroups[i].right[e[j]] == k) {%> selected="true"<%}%>><%=arrUserRight[e[j]].rights[k]%></option><%}%>
					</select>
				</td><%}%>
			</tr><%}%>
		</tbody>
		</form>
	</table>
</div>
<%
	thePage.outputSidebar();
	thePage.outputEnd();
}
%>
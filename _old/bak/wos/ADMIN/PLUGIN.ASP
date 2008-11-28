<!-- #include file = "common/common.asp" -->
<!-- #include file = "source/plugin.asp" -->
<%
function outputPlugin(arrPlugins) {
	thePage.outputStart(getLang("plugin_center") + " - ");
%>
<div id="plugin">
	<%thePage.outputH2(getLang("plugin_center"))%>
	<table class="form">
		<form method="post" action="?act=submit" onsubmit="for (var i = 0; i < getElementsByName('plug_delete').length; i++){if (getElementsByName('plug_delete')[i].checked == true){return confirm('<%=getLang("confirm_to_delete_desc")%>?')}}">
		<thead>
			<tr>
				<th scope="col"><%=getLang("delete")%></th>
				<th scope="col"><%=getLang("name")%></th>
				<th scope="col"><%=getLang("database_path")%></th>
				<th scope="col"><%=getLang("in_folder")%></th>
				<th scope="col"><%=getLang("manage")%></th>
			</tr>
		</thead>
		<tfoot>
			<tr>
				<td colspan="5"><input type="submit" value="<%=getLang("submit")%>" class="submit" /></td>
			</tr>
		</tfoot>
		<tbody><%if (!arrPlugins) {%>
			<tr class="msg"><td colspan="5"><%=getLang("no_plugins_desc")%></td></tr><%} else { for (var i = 0; i < arrPlugins.length; i++) {%>
			<tr>
				<td><input type="checkbox" name="plug_delete" value="<%=arrPlugins[i].id%>" /><input type="hidden" name="plug_id" value="<%=arrPlugins[i].id%>" /></td>
				<td><input type="text" name="plug_name" size="10" value="<%=arrPlugins[i].name%>" /></td>
				<td><input type="text" name="plug_dbPath" value="<%=arrPlugins[i].dbPath%>" /></td>
				<td><input type="text" name="plug_folder" size="10" value="<%=arrPlugins[i].folder%>" /></td>
				<td><a href="<%=arrPlugins[i].adminFolder%>"><%=getLang("manage")%></a></td>
			</tr><%} }%>
		</tbody>
		<tbody id="add">
			<tr>
				<th scope="row"><%=getLang("new")%>:<input type="hidden" name="plug_id" value="0" /></th>
				<td><input type="text" name="plug_name" size="10" class="text" /></td>
				<td><input type="text" name="plug_dbPath" class="text" /></td>
				<td><input type="text" name="plug_folder" size="10" class="text" /></td>
				<td>&nbsp;</td>
			</tr>
		</tbody>
		</form>
	</table>
</div>
<%
	thePage.outputSidebar();
	thePage.outputEnd();
}
%>
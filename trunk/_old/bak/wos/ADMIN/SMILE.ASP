<!-- #include file = "common/common.asp" -->
<!-- #include file = "source/smile.asp" -->
<%
function outputList(arrSmiles) {
	thePage.outputStart(getLang("smile_icon") + " - ");
%>
<div id="smiles">
	<%thePage.outputH2(getLang("smile_icon"))%>
	<table class="form">
		<form method="post" action="?act=submit" onsubmit="for (var i = 0; i < getElementsByName('sm_delete').length; i++){if (getElementsByName('sm_delete')[i].checked == true){return confirm('<%=getLang("confirm_to_delete_desc")%>?')}}">
		<thead>
			<tr>
				<th scope="col"><%=getLang("delete")%></th>
				<th scope="col"><%=getLang("picture")%></th>
				<th scope="col"><%=getLang("name")%></th>
				<th scope="col"><%=getLang("file_name")%></th>
			</tr>
		</thead>
		<tfoot>
			<tr>
				<td colspan="4"><input type="submit" value="<%=getLang("submit")%>" class="submit" /></td>
			</tr>
		</tfoot>
		<tbody><%if (!arrSmiles) {%>
			<tr class="msg"><td colspan="4"><%=getLang("no_smiles_desc")%></td></tr><%} else { for (var i = 0; i < arrSmiles.length; i++) {%>
			<tr>
				<td><input type="checkbox" name="sm_delete" value="<%=arrSmiles[i].id%>" /><input type="hidden" name="sm_id" value="<%=arrSmiles[i].id%>" /></td>
				<td><img src="<%=arrSmiles[i].filePath%>" alt="<%=arrSmiles[i].name%>" /></td>
				<td><input type="text" name="sm_name" value="<%=arrSmiles[i].name%>" /></td>
				<td><input type="text" name="sm_file" value="<%=arrSmiles[i].file%>" /></td>
			</tr><%} }%>
		</tbody>
		<tbody id="add">
			<tr>
				<th scope="row" colspan="2"><%=getLang("new")%>:<input type="hidden" name="sm_id" value="0" /></th>
				<td><input type="text" name="sm_name" class="text" /></td>
				<td><input type="text" name="sm_file" class="text" /></td>
			</tr>
		</tbody>
		</form>
	</table>
	<p class="tip"><%=getLang("smile_desc")%></p>
</div>
<%
	thePage.outputSidebar();
	thePage.outputEnd();
}

%>
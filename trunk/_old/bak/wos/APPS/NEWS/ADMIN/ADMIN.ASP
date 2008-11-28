<!-- #include file = "common/common.asp" -->
<!-- #include file = "source/admin.asp" -->
<%
function outputAdmin(arrInfo) {
	thePage.outputStart(getLang("news_system_manage") + " - " + getLang("general_infomation") + " - ");
%>
<div id="info">
	<%thePage.outputH2(getLang("general_infomation"))%>
	<table class="list">
		<tbody>
			<tr>
				<th scope="row"><%=getLang("plugin_version")%>:</th>
				<td><%=arrInfo.version%></td>
			</tr>
			<tr>
				<th scope="row"><%=getLang("plugin_path")%>:</th>
				<td><%=arrInfo.pluginPath%></td>
			</tr>
		</tbody>
	</table>
</div>
<%
	thePage.outputSidebar();
	thePage.outputEnd();
}
%>
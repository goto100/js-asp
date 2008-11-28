<!-- #include file = "common/common.asp" -->
<!-- #include file = "source/admin.asp" -->
<%
function outputAdmin(arrInfo) {
	thePage.outputStart(getLang("general_infomation") + " - ");
%>
<div id="info">
	<%thePage.outputH2(getLang("general_infomation"))%>
	<table class="list">
		<tbody>
			<tr>
				<th scope="row"><%=getLang("site_version")%>:</th>
				<td><%=theSite.version%></td>
			</tr>
			<tr>
				<th scope="row"><%=getLang("site_operate")%>:</th>
				<td><%if (!theCache.setting.siteOpened) {%><a href="?act=opensite"><%=getLang("open_site")%></a><%} else {%><a href="?act=closesite"><%=getLang("close_site")%></a><%}%> | <a href="?cache=clean"><%=getLang("clean_cache")%></a></td>
			</tr>
			<tr>
				<th scope="row"><%=getLang("server_software")%>:</th>
				<td><%=arrInfo.serverSoftware%></td>
			</tr>
			<tr>
				<th scope="row"><%=getLang("server_time")%>:</th>
				<td><%=arrInfo.serverTime%></td>
			</tr>
			<tr>
				<th scope="row"><%=getLang("server_ip")%>:</th>
				<td><%=arrInfo.serverIP%></td>
			</tr>
			<tr>
				<th scope="row"><%=getLang("application_path")%>:</th>
				<td><%=arrInfo.applicationPath%></td>
			</tr>
			<tr>
				<th scope="row"><%=getLang("script_engine")%>:</th>
				<td><%=parseFloat(arrInfo.scriptEngine.slice(0, 3))<5.5? "<strong class=\"important\">" + arrInfo.scriptEngine + "</strong>":arrInfo.scriptEngine%></td>
			</tr>
			<tr>
				<th scope="row"><%=getLang("obj_fso")%>:</th>
				<td><%=arrInfo.fsoSuppose? getLang("yes"):"<strong class=\"important\">" + getLang("no") + "</strong>"%></td>
			</tr>
			<tr>
				<th scope="row"><%=getLang("obj_xmlhttp")%>:</th>
				<td><%=arrInfo.xmlHttpSuppose? getLang("yes"):"<strong class=\"important\">" + getLang("no") + "</strong>"%></td>
			</tr>
			<tr>
				<th scope="row"><%=getLang("obj_xmldom")%>:</th>
				<td><%=arrInfo.xmlDomSuppose? getLang("yes"):"<strong class=\"important\">" + getLang("no") + "</strong>"%></td>
			</tr>
			<tr>
				<th scope="row"><%=getLang("obj_stream")%>:</th>
				<td><%=arrInfo.streamSuppose? getLang("yes"):"<strong class=\"important\">" + getLang("no") + "</strong>"%></td>
			</tr>
		</tbody>
	</table>
	<p class="note"><%=getLang("object_desc")%></p>
</div>
<%
	thePage.outputSidebar();
	thePage.outputEnd();
}
%>
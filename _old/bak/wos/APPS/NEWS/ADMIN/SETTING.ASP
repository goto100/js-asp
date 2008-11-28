<!-- #include file = "common/common.asp" -->
<!-- #include file = "source/setting.asp" -->
<%
function outputSetting() {
	thePage.outputStart(getLang("news_system_manage") + " - " + getLang("general_setting") + " - ");
%>
<div id="setting">
	<%thePage.outputH2(getLang("general_setting"))%>
</div>
<%
	thePage.outputSidebar();
	thePage.outputEnd();
}
%>
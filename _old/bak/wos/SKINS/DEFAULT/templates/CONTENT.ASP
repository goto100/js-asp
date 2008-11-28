<!-- #include file = "template.asp" -->
<%

thePage.outputStart = function() {
	thePage.load();
	thePage.outputHeader();
	thePage.outputUserInfo();
	thePage.outputNav();
	thePage.loadMainWrapper();
	thePage.loadMain();
}

thePage.outputEnd = function() {
	thePage.unloadMain();
	thePage.unloadMainWrapper();
	thePage.outputFooter();
	thePage.unload();
}

thePage.outputSidebar = function() {
	this.unloadMain();
%>
<div id="sidebar">
<div id="innerSidebar">
<%
	this.outputPanels();
%>
</div>
</div>
<%
}
%>
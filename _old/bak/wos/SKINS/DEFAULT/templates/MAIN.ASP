<!-- #include file = "template.asp" -->
<%

thePage.outputStart = function() {
	thePage.load();
	thePage.outputHeader();
	thePage.outputUserInfo();
	thePage.outputNav();
	thePage.loadMainWrapper();
	thePage.loadMain(true);
}

thePage.outputEnd = function() {
	thePage.unloadMain();
	thePage.unloadMainWrapper();
	thePage.outputFooter();
	thePage.unload();
}
%>
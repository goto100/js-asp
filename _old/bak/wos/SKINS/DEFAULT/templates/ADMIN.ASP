<!-- #include file = "template.asp" -->
<%
thePage.noCache = true;
thePage.addScript("admin.js");

thePage.addPanel(getLang("site_manage"), ["<a href=\"" + theCache.setting.sitePath + "/admin/admin.asp\">" + getLang("general_infomation") + "</a>"
																	, "<a href=\"" + theCache.setting.sitePath + "/admin/setting.asp\">" + getLang("general_setting") + "</a>"
																	, "<a href=\"" + theCache.setting.sitePath + "/admin/category.asp\">" + getLang("category_manage") + "</a>"
																	, "<a href=\"" + theCache.setting.sitePath + "/admin/usergroup.asp\">" + getLang("user_group") + "</a>"
																	, "<a href=\"" + theCache.setting.sitePath + "/admin/smile.asp\">" + getLang("smile_icon") + "</a>"
																	, "<a href=\"" + theCache.setting.sitePath + "/admin/plugin.asp\">" + getLang("plugin_center") + "</a>"
																	]
								);

thePage.outputStart = function(strTitle) {
	thePage.load(getLang("site_manage") + " - " + strTitle);
	thePage.outputHeader();
	thePage.loadMainWrapper();
	thePage.loadMain();
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

thePage.outputEnd = function() {
	thePage.unloadMainWrapper();
	thePage.outputFooter();
	thePage.unload();
}

%>
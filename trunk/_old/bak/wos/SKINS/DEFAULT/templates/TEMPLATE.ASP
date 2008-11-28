<%
////////////////////////////////////////////////////////////
// Class WOSPage
//
// Last modify: 2005/6/1
// Author: ScYui
//
// Attributes: 
// Methods: 
////////////////////////////////////////////////////////////

function WOSPage() {
	////////// Attributes //////////////////////////////
	// Private //////////
	var panels = [];

	var alertType = 0;
	var alertTitle = getLang("error");
	var alertContent = [];
	var alertLink = "<a href=\"javascript:history.go(-1)\">" + getLang("click_to_go_back") + "</a>";

	// Public //////////
	this.mainFullWidth = false;

	this.charset = "utf-8";
	this.language = "zh-cn";
	this.author = "ScYui";
	this.keywords = "WOS, web, ";
	this.description = "The Program of Fans Website";
	this.robots = "all";
	this.icon = "";
	this.noCache = false;
	this.title = "WOS";
	this.csses = ["style.css"];
	this.scripts = ["script.js"];

	////////// Methods //////////////////////////////
	// Private //////////

	// Get the page's file name
	// This can get file name of the page, it's maybe used in body body's id
	function getPageName() {
		var pageName = String(Request.ServerVariables("PATH_INFO"));
		pageName = pageName.substring(pageName.lastIndexOf("/") + 1);
		return pageName.substring(0, pageName.lastIndexOf("."));
	}

	// Public //////////

	// Add css
	this.addCSS = function(strPath) {
		this.csses.push(strPath);
	}

	// Add script
	this.addScript = function(strPath) {
		this.scripts.push(strPath);
	}

	// Load page
	// All pages load this first
	this.load = function(strTitle, arrCSS) {
		if (strTitle) this.title = strTitle + this.title;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head><%if (this.charset) {%>
	<meta http-equiv="content-type" content="text/html; charset=<%=this.charset%>" /><%} if (this.language) {%>
	<meta http-equiv="Content-Language" content="<%=this.language%>" /><%} if (this.author) {%>
	<meta name="author" content="<%=this.author%>" /><%} if (this.keywords) {%>
	<meta name="keywords" content="<%=this.keywords%>" /><%} if (this.description) {%>
	<meta name="description" content="<%=this.description%>" /><%} if (this.robots) {%>
	<meta name="robots" content="<%=this.robots%>" /><%} if (this.noCache) {%>
	<meta http-equiv="pragma" content="no-cache" /><%} if (this.icon) {%>
	<link rel="Shortcut Icon" href="<%=this.icon%>" type="image/x-icon" /><%} if (this.csses) { for (var i = 0; i < this.csses.length; i++) {%>
	<link href="<%=theCache.setting.sitePath + "/skins/" + theCache.setting.defaultSkin + "/styles/" + theCache.setting.defaultStyle + "/" + this.csses[i]%>" rel="stylesheet" type="text/css" /><%} } if (this.scripts) { for (var i = 0; i < this.scripts.length; i++) {%>
	<script src="<%=theCache.setting.sitePath + "/skins/" + theCache.setting.defaultSkin + "/scripts/" + this.scripts[i]%>" type="text/javascript" language="javascript"></script><%} } if (this.title) {%>
	<title><%=this.title%></title><%}%>
</head>
<body id="" class="plugin_">
<div id="" class="plugin_<%=getPageName()%>">
<div id="wrapper" class="">
<div id="innerWrapper">
<%
	}

	// Unload page
	// If you loaded page, you must unload it
	this.unload = function() {
%>
</div>
</div>
</div>
</body>
</html>
<%
	}

	// The div of Header
	this.outputHeader = function() {
%>
<!-- Header start -->
<div id="header">
<div id="innerHeader">
	<h1 id="siteName"><a href="<%=theCache.setting.sitePath%>" title="<%=theCache.setting.siteDescription%>"><%=theCache.setting.siteName%></a></h1>
</div>
</div>
<!-- Header end -->
<%
	}

	// The div of Nav
	// This is always after Header
	this.outputNav = function() {
%>
<!-- Nav start -->
<div id="nav">
<div id="innerNav">
	<ul><%for (var i = 0; i < theCache.categories.length; i++) {%>
		<li><a href="<%=theCache.categories[i].url%>" title="<%=theCache.categories[i].intro%>"><%=theCache.categories[i].name%></a></li><%}%>
	</ul>
</div>
</div>
<!-- Nav end -->
<%
	}

	// The div of userInfo
	this.outputUserInfo = function() {
%>
<!-- UserInfo start -->
<div id="userInfo">
<div id="innerUserInfo">
	<ul>
	<%if (theUser.loggedIn) {%><li><%=getLang("welcome") + theUser.group.name + ":" + theUser.username%></li>
	<li><a href="<%=theCache.setting.sitePath%>/login.asp?act=dologout"><%=getLang("logout")%></a></li><%} else {%>
	<li><%=getLang("not_logged_in")%></li>
	<li><a href="<%=theCache.setting.sitePath%>/login.asp"><%=getLang("login")%></a></li>
	<li><a href="<%=theCache.setting.sitePath%>/register.asp"><%=getLang("register")%></a></li><%}%>
	</ul>
</div>
</div>
<!-- UserInfo end -->
<%
	}

	// The div of Footer
	this.outputFooter = function() {
		theSite.processTime = new Date() - theSite.processTime;
%>
<!-- Footer start -->
<div id="footer">
<div id="innerFooter">
	<ul id="siteInfo">
		<li><a href="<%=theCache.setting.sitePath%>/admin/"><%=getLang("site_manage")%></a></li>
		<li><a href="?cache=clean">Clean Cache</a></li>
	</ul>
	<p id="serverInfo">Processed in <span class="runtime"><%=theSite.processTime%></span> ms <span class="rsnumber"><%=DBConn.queryCount%></span> DB Queries</p>
<%
	if (getSession("RunTimeTest") && getSession("RunTimeTestNum")) {
		setSession("RunTimeTest", getSession("RunTimeTest") + theSite.processTime);
		setSession("RunTimeTestNum", getSession("RunTimeTestNum") + 1);
	}
	if (query["runtimetest"] == "start") {
		setSession("RunTimeTest", 0);
		setSession("RunTimeTestNum", 0);
	}
	if (query["runtimetest"] == "clean") {
		Session.Contents.Remove("RunTimeTest");
		Session.Contents.Remove("RunTimeTestNum");
	}
%>
</div>
</div>
<!-- Footer end -->
<%if (theSite.debugMode) {%>
<div id="runtimetest">
	<table>
		<thead>
			<tr>
				<th>性能调试</th>
				<th>次数</th>
				<th>平均</th>
				<th>操作</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td><%=getSession("RunTimeTest")? Number(getSession("RunTimeTest")): 0%> ms</td>
				<td><%=getSession("RunTimeTestNum")? Number(getSession("RunTimeTestNum")): 0%></td>
				<td><%=getSession("RunTimeTestNum")? Number(getSession("RunTimeTest"))/Number(getSession("RunTimeTestNum")): 0%></td>
				<td><%if (!getSession("RunTimeTestNum")) {%><a href="?runtimetest=start">Start</a><%} else {%><a href="?runtimetest=clean">Clean</a><%}%></td>
			</tr>
		</tbody>
	</table>
</div>
<%if (DBConn.debugDatabase) {%><div id="debugDatabase">
	<ul><%for (var i = 0; i < DBConn.debugDatabase.length; i++) {%>
		<li><%=DBConn.debugDatabase[i]%></li><%}%>
	</ul>
</div><%}%>
<%}%>
<%
		DBConn.closeAll();
	}

	// Load wrapper of Main
	this.loadMainWrapper = function() {
%>
<!-- MainWrapper start -->
<div id="mainWrapper">
<div id="innerMainWrapper">
<%
	}

	// Unload wrapper of Main
	this.unloadMainWrapper = function() {
%>
<span class="clear"></span>
</div>
</div>
<!-- MainWrapper end -->
<%
	}

	// Load Main
	// A page must have main content, so you have to load main first
	this.loadMain = function(bFullWidth) {
		if (bFullWidth) this.mainFullWidth = true;
%>
<!-- Main start -->
<div id="main"<%if (this.mainFullWidth) {%> class="fullWidth"<%}%>>
<div id="innerMain">
<%
	}

	// Unload Main
	// If you loaded the main, you must unload it
	this.unloadMain = function() {
%>
</div>
</div>
<!-- Main end -->
<%
	}

	// Panels in Sidebar
	// Some pages have sidebar, there are panels in it
	this.outputPanels = function() {
			if (panels) for (var i = 0; i < panels.length; i++)
 write(panels[i]);
	}

	// Add panel
	// You can add one panel use this method
	this.addPanel = function(strTitle, objItems) {
		if (objItems.constructor == Array) {
			var content = "\t<ul>\r\n";
			for (var i = 0; i < objItems.length; i++) {
				content += "\t\t<li>" + objItems[i] + "</li>\r\n";
			}
			content += "\t</ul>\r\n";
		} else if (objItems.constructor == String) {
			content = "\t\t<ul><li>" + objItems + "</li></ul>\r\n";
		}
		if (strTitle) content = "\t<h2>" + strTitle + "</h2>\r\n" + content;
		panels.push("<div class=\"panel\">\r\n" + content + "</div>\r\n");
	}

	// Output h2
	// This is always in div Main
	this.outputH2 = function(strContent) {
		write("<h2>" + strContent + "</h2>");
	}

	// Output alert page
	this.outputAlert = function(arrItems) {
		if (arrItems) {
			if (arrItems.constructor == String) {
				alertContent.push(arrItems);
			} else {
				if (arrItems[1]) alertType = arrItems[1];
				if (arrItems[2]) alertTitle = arrItems[2];
				if (!arrItems[0]) arrItems[0] = getLang("unknow_error_desc");
				if (arrItems[0].constructor == Array) {
					for (var i = 0; i < arrItems[0].length; i++) {
						alertContent.push(arrItems[0][i]);
					}
				} else if (arrItems[0].constructor == String || arrItems[0].constructor == Number) {
					alertContent.push(arrItems[0]);
				}
				if (arrItems[3]) alertLink = arrItems[3];
			}
		}
		if (alertContent[0] == undefined) alertContent.push(getLang("unknow_error_desc"));

		this.load();
		this.outputHeader();
		this.loadMainWrapper();
		this.loadMain(true);

	%>
	<div id="alert">
	<h2><%=alertTitle%></h2>
	<ul>
		<%for (var i = 0; i < alertContent.length; i++) {%><li><%=alertContent[i]%></li>
	<%}%></ul>
	<p class="link">[ <%=alertLink%> ]</p>
	</div>
	<%
		this.unloadMain();
		this.unloadMainWrapper();
		this.outputFooter();
		this.unload();
		Response.End();
	}
}

var thePage = new WOSPage();
%>
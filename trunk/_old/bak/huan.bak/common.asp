<!--#include file=".common/common.asp" -->
<!--#include file=".class/controller/HuanController.asp" -->
<!--#include file=".class/model/HuanSystem.asp" -->
<%
// Initialization
Response.Buffer = true;
Server.ScriptTimeOut = 90;

Session.LCID = 2048;
// Session.LCID = 2057;

Session.CodePage = 65001;
// Session.CodePage = 936;

// Response.Charset = "utf-8";
Response.Charset = "gb2312";

var START_TIME = new Date;
var PATH_DEPTH = 1;
var NAME_SPACE = "huan:";
var MAIN_DB_PATH = Server.MapPath("/../database/huan.mdb");

	this.visitor = system.getVisitor(0, system.getUserGroup(2));
	if (Boolean(this.getCookie("userLoggedIn")) || Boolean(this.getCookie("remState"))) {
		try {
			this.visitor.visit(parseInt(this.getCookie("userId")), this.getCookie("userPassword"));
		} catch(e) {
			this.removeCookie("userLoggedIn");
			this.removeCookie("userrId");
			this.removeCookie("userPassword");
		}
	} else this.visitor.visit();
	if (this.request.search.o == "html") this.contentType = View.HTML;
	this.name = system.name;
	this.language = system.setting.defaultLanguage;
	this.pageSkin = system.setting.defaultSkin;
	if (this.request.search.o == "html") system.setSession("pageContentType", View.HTML);
	if (this.request.search.o == "xml") system.setSession("pageContentType", View.XML);
	this.pageContentType = system.getSession("pageContentType");
	this.load();
	if (this.pageName.indexOf("admin") == -1 && !system.setting.siteOpened) this.outputPage("siteClosed");
	this.checkPermission(this.visitor.getRight("viewSite"));
	//this.visitor.login("scyui@hotmail.com", "c4289321c14b32e21f56116a1ad36c970c5b8cd0");

%>
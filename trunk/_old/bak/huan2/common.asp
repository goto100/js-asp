<!--#include file=".common.asp" -->
<!--#include file=".class/system/HuanSystem.asp" -->
<script language="javascript" runat="server">
var controller = new Controller(PATH_DEPTH);
var system = new HuanSystem(MAIN_DB_PATH);
system.load();
system.user.ip = controller.request.ip;
system.user.os = controller.request.os;
system.user.browser = controller.request.browser;
system.user.referer = controller.request.referer;
system.user.target = controller.request.path;
if (Boolean(controller.getCookie("userLoggedIn")) || Boolean(controller.getCookie("remState"))) {
	try {
		system.user.visit(parseInt(controller.getCookie("memberId")), controller.getCookie("memberPassword"));
	} catch(e) {
		controller.removeCookie("userLoggedIn");
		controller.removeCookie("memberId");
		controller.removeCookie("memberPassword");
	}
} else system.user.visit();
var outputer = new MainOutputer(controller);
if (controller.request.search.o == "html") controller.contentType = "html";
controller.name = system.name;
controller.language = system.setting.defaultLanguage;
controller.pageSkin = system.setting.defaultSkin;
controller.visitor = system.user;
if (controller.request.search.o == "html") system.setSession("pageContentType", "html");
if (controller.request.search.o == "xml") system.setSession("pageContentType", "xml");
controller.pageContentType = system.getSession("pageContentType");
controller.load();
if (controller.pageName.indexOf("admin") == -1 && !system.setting.siteOpened) controller.outputPage("siteClosed");
controller.checkPermission(system.user.getRight("viewSite"));
system.user.login("scyui@hotmail.com", "c4289321c14b32e21f56116a1ad36c970c5b8cd0");
Main();
controller.execute();
</script>
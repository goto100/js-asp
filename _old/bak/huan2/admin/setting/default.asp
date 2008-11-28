<!--#include file="../../common.asp" -->
<!--#include file="default.source.asp" -->
<%
function MainOutputer(controller) {
	this.outputForm = function(value) {
		var page = controller.getPage(new FormPage("form", value));
		page.content.addInfo("setting").addForms("siteName", "siteURL", "defaultLanguage", "siteOpened");

		page.output();
	}
}
%>
<!--#include file="../../common.asp" -->
<!--#include file="default.source.asp" -->
<%
function MainOutputer(controller) {
	this.outputForm = function(value) {
		var page = controller.getPage(new FormPage("form", value));
		page.content.addInfo("setting").addForms("blogName", "blogTitle", "blogURL", "masterName", "masterEmail");

		page.output();
	}
}
%>
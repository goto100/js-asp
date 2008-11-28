<!--#include file="../../common.asp" -->
<!--#include file="default.source.asp" -->
<%
function MainOutputer(controller) {
	this.outputAgreement = function(agreement) {
		var page = controller.getPage(new Page("agreement"));
		page.content.setContent(agreement);
		page.output();
	}

	this.outputForm = function(value) {
		var page = controller.getPage(new FormPage("form", value));
		page.content.addInfo("member").addForms("userId", "password", "rePassword", "nickname", "secQuestion", "secAnswer");
		page.output();
	}

	this.outputRegisted = function() {
		controller.outputPage("registed");
	}
}
%>
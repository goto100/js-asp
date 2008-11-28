<!--#include file="../../common.asp" -->
<!--#include file="default.source.asp" -->
<%
function MainOutputer(controller) {
	this.outputForm = function(value) {
		var page = controller.getPage(new FormPage("form", value));
		page.content.addInfo("member").addForms("userId", "password", "rePassword");
		page.content.addInfo("login").addForms("remState");

		page.output();
	}

	this.outputSuccess = function() {
		controller.outputPage("loggedIn");
	}

	this.outputLoggedIn = function() {
		controller.outputPage("alreadyLoggedIn");
	}
}
%>
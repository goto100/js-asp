<!--#include file="../../common.asp" -->
<!--#include file="default.source.asp" -->
<%
function MainOutputer(controller) {
	this.outputSuccess = function() {
		controller.outputPage("loggedOut");
	}

	this.outputNogLoggedIn = function() {
		controller.outputPage("notLoggedIn");
	}
}
%>
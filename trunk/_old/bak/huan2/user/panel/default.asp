<!--#include file="../../common.asp" -->
<!--#include file="default.source.asp" -->
<% 
function MainOutputer(controller) {

	this.outputEditForm = function(value) {
		var page = controller.getPage(new FormPage("edit", value, ".?update"));
		page.content.addInfo("member").addForms("userId", "password", "rePassword", "nickname", "secQuestion", "secAnswer");

		page.output();
	}
}
%>
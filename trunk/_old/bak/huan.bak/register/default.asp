<!--#include file="../common.asp" -->
<!--#include file="../.class/view/RegisterFormView.asp" -->
<%
function Main()
{
	var actForm = controller.addAction(new FormAction);

	actForm.action = function()
	{
		if (controller.visitor.loggedIn) controller.outputPage("alreadyLoggedIn");
		else controller.getPage(new RegisterFormView(this.getValue("userId"))).output();
	}
}
%>
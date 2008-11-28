<%
function Main() {
	var actLogout = controller.addAction(new Action);

	actLogout.action = function() {
		if (!system.user.loggedIn) outputer.outputNogLoggedIn();
		else {
			system.user.logout();
			controller.removeCookie("userLoggedIn");
			controller.removeCookie("memberId");
			controller.removeCookie("memberPassword");
			outputer.outputSuccess();
		}
	}
}
%>
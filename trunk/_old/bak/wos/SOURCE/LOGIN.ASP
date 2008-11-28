<%
switch(query["act"]) {
	case "dologin":
		if (theUser.loggedIn) {
			thePage.outputAlert([getLang("already_logged_in_desc")]);
		} else if (query["username"] && query["password"] && query["cookietime"]) {
			Session.Contents.Remove("SecurityCode");
			thePage.outputAlert(theUser.login(query["username"], query["password"], query["cookietime"], query["scode"]));
		} else {
			if (!query["username"]) thePage.outputAlert([getLang("username") + getLang("incomplete")]);
			if (!query["password"]) thePage.outputAlert([getLang("password") + getLang("incomplete")]);
			if (!query["cookietime"]) thePage.outputAlert([getLang("cookie_time") + getLang("unselected")]);
		}
		break;

	case "dologout":
		if (!theUser.loggedIn) {
			thePage.outputAlert([getLang("not_logged_in_desc")]);
		} else {
			theUser.logout();
			thePage.alertTitle = getLang("logout_success");
			thePage.outputAlert([getLang("logout_success_desc")]);
		}

		break;

	default:
		if (theUser.loggedIn) {
		thePage.outputAlert([getLang("already_logged_in_desc")]);
		} else {
			theCache.genSecurityCode();
			outputLogin();
		}
}

var thePage = new WOSPage();
%>
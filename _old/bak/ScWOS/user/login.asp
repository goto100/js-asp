<!-- #include file = "common.asp" -->
<!-- #include file = "../common/classes/dbform.asp" -->
<%
if (search.logout != null) {
	user.logout();
	page.outputMsg("logoutSuccess", lang["logout_success"]);

} else if (getSiteSession("userLoggedIn")) {
	page.outputMsg("loggedIn", lang["already_logged_in"]);

} else if (search.submit != null) {
	var form = fillForm(true);

	if (form.submit(input)) {
		var tmpA = sys.conn.query("SELECT TOP 1 [id], [password]"
			+ " FROM [Members]"
			+ " WHERE [email] = '" + input.email + "'");
		if (tmpA != null) {
			user.login(tmpA["id"], tmpA["password"]);

			if (form.item.remState.value) {
				var tDate = new Date();
				tDate.setTime(tDate.getTime() + 365 * 864E5);
				setSiteCookie("remState", true, tDate);
				setSiteCookie("memberId", tmpA["id"], tDate);
				setSiteCookie("memberPassword", tmpA["password"], tDate);
			}
		}
		page.outputMsg("loginSuccess", lang["login_success"], true);
	} else {
		page.setRoot("form", "form")
		form.addNodeToPage(page.content);
		page.output();
	}

} else {
	page.getReferer();
	var form = fillForm();
	page.setRoot("form", "form")
	form.addNodeToPage(page.content);
	page.output();
}

function fillForm(isSubmit) {
	var form = new DBForm();
	form.mode = "edit";
	form.action = "submit";
	form.secCode = sys.setting.memberLoginSecCode;

	var email = form.addItem("sign", "email", "string", true, lang["email_must"]);
	var password = form.addItem(false, "password", "string", true, lang["password_must"]);
	form.addItem(false, "remState", "boolean");
	if (form.secCode) var secCode = form.addItem(false, "secCode", "string", true, lang["sec_code_must"]);
	if (isSubmit) {
		form.conn = conn;
		form.table = "Members";

		var codedPassword = "";
		var tmpA = sys.conn.query("SELECT TOP 1 [email], [password]"
			+ " FROM [Members]"
			+ " WHERE email='" + email.value + "'");
		if (!tmpA) { email.error = lang["email_empty"];
		else codedPassword = tmpA["password"];

		if (codedPassword && code(password.value) != codedPassword) password.error = lang["password_wrong"];
		if (form.secCode) {
			if (secCode.value != getSiteSession("loginSecCode")) secCode.error = lang["sec_code_wrong"];
		}

		form.addSubmit("lastIP", getIP());
		form.addSubmit("lastVisit", new Date());
	}
	return form;
}
%>

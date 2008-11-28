<!-- #include file = "common.asp" -->
<!-- #include file = "../common/classes/dbform.asp" -->
<%
if (search.agreement == null && (getSiteSession("agreedRegisterAgreement") == true || input.agree)) {
	setSiteSession("agreedRegisterAgreement", true);

	if (search.submit != null) {
		var form = fillForm(true);

		if (form.submit(input)) {
			removeSiteSession("agreedRegisterAgreement");
			page.outputMsg("registerSuccess", lang["register_success"], true);
		} else outputRegisterForm();
	} else if (search.checkemail != null && search.email) {
		var form = new DBForm();
		form.mode = "check";
		fillFormEmail(form);

		if (form.submit(search)) page.outputMsg("emailCanUse", lang["email_can_use"]);
		else page.outputMsg("emailUsed", form.item.email.error);
	} else {
		var form = fillForm();
		outputRegisterForm();
	}

} else if (input.disagree) {

} else {
	page.getReferer();
	page.setRoot("agreement", "agreement");
	page.content.setContent(lang["agreement"]);
	page.output();
}

function fillForm(isSubmit) {
	var form = new DBForm();
	form.mode = "add";
	form.action = "submit";
	form.secCode = sys.setting.memberRegisterSecCode;

	fillFormEmail(form);
	var password = form.addItem(false, "password", "string", true, lang["password_must"]);
	password.setMinLength(sys.setting.memberPasswordMinLength, lang["password_short"]);
	password.setMaxLength(sys.setting.memberPasswordMaxLength, lang["password_long"]);
	var nickname = form.addItem(true, "nickname", "string", true, lang["nickname_must"]);
	nickname.setMinLength(sys.setting.memberNicknameMinLength, lang["nickname_short"]);
	nickname.setMaxLength(sys.setting.memberNicknameMaxLength, lang["nickname_long"]);
	var secQuestion = form.addItem(true, "secQuestion", "string", true, lang["sec_question_must"]);
	secQuestion.setMinLength(sys.setting.memberSecQuestionMinLength, lang["sec_question_short"]);
	secQuestion.setMaxLength(sys.setting.memberSecQuestionMaxLength, lang["sec_question_long"]);
	var secAnswer = form.addItem(true, "secAnswer", "string", true, lang["sec_answer_must"]);
	secAnswer.setMinLength(sys.setting.memberSecAnswerMinLength, lang["sec_answer_short"]);
	secAnswer.setMaxLength(sys.setting.memberSecAnswerMaxLength, lang["sec_answer_long"]);
	form.addItem(true, "firstName", "string");
	form.addItem(true, "lastName", "string");
	form.addItem(true, "gender", "number");
	form.addItem(true, "zipcode", "string");
	if (form.secCode) var secCode = form.addItem(false, "secCode", "string", true, lang["sec_code_must"]);

	if (isSubmit) {
		form.conn = conn;
		form.table = "Members";

		form.addSubmit("password", code(input.password));
		form.addSubmit("groupId", 3);
		form.addSubmit("lastIP", getIP());
		form.addSubmit("lastVisit", new Date());
		if (form.secCode) {
			if (secCode.value != getSiteSession("registerSecCode")) secCode.error = lang["sec_code_wrong"];
		}
	}

	return form;
}

function fillFormEmail(form) {
	var email = form.addItem(true, "email", "string", true, lang["email_must"]);
	email.setMatch(/^[\w]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$/ig, lang["email_error"]);
	var tmpA = sys.conn.query("SELECT TOP 1 [email]"
		+ " FROM [Members]"
		+ " WHERE email='" + email.value + "'");
	if (tmpA != null) email.error = lang["email_registed"];
}

function outputRegisterForm() {
	page.setRoot("form", "form")
	form.addNodeToPage(page.content);
	page.output();
}
%>

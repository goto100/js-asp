<%
function Main() {
	var actAgreement, actForm, actSubmit;

	actAgreement = controller.addAction(new Action, (!controller.request.search[0]) || (controller.request.search[0] == "agreement"));
	actForm = controller.addAction(new FormAction, Boolean(controller.request.input.agree));
	actSubmit = controller.addAction(new DBAction, "submit");

	actAgreement.action = function() {
		outputer.outputAgreement(this.lang("agreement"));
	}

	actForm.action = function() {
		outputer.outputForm(this.getValue());
	}

	actSubmit.action = function() {
		var member;

		this.withEmailParam("userId", true);
		this.withStringParam("password", true, 6, 28);
		this.withStringParam("rePassword", true, null, null, this.param.password);
		this.withStringParam("nickname", true);
		this.withStringParam("secQuestion", true);
		this.withStringParam("secAnswer", true);
		if (!this.form.userId.error && system.user.checkUserIdUsed(this.param.userId)) this.setParamError("userId", new Error(5, this.lang("userIdRegisted")));
		if (this.hasError) outputer.outputForm(this.form);
		else {
			member = system.getUser();
			member.save(this.param);
			outputer.outputRegisted();
		}
	}
}
%>
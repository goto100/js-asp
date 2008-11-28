<%
function Main() {
	var actForm = controller.addAction(new FormAction);
	var actSubmit = controller.addAction(new DBAction, "submit");

	actForm.action = function() {
		if (system.user.loggedIn) outputer.outputLoggedIn();
		else outputer.outputForm(this.getValue("userId"));
	}

	actSubmit.action = function() {
		if (system.user.loggedIn) outputer.outputLoggedIn();
		else {
			this.withStringParam("userId", true);
			this.withStringParam("password", true);
			this.withStringParam("rePassword", true, null, null, this.param.password);
			this.withBooleanParam("remState");
	
			try {
				system.user.login(this.param.userId, system.encode(this.param.password));
			} catch(e) {
				if (e.number == 0) {
					e.description = this.lang("userIdEmpty");
					this.setParamError("userId", e);
				} else if (e.number == 1) {
					e.description = this.lang("passwordWrong");
					this.setParamError("password", e);
				}
			}
			if (this.hasError) outputer.outputForm(this.form);
			else {
				var eDate;
				if (this.param.remState) {
					eDate = new Date(system.now);
					eDate.setYear(eDate.getYear() + 1);
				}
				controller.setCookie("userLoggedIn", true, eDate);
				controller.setCookie("memberId", system.user.id, eDate);
				controller.setCookie("memberPassword", system.user.password, eDate);
	
				outputer.outputSuccess();
			}
		}
	}
}
%>
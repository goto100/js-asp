<%
function Main() {
	controller.checkPermission(system.user.getRight("administer"));

	var actForm = controller.addAction(new FormAction);
	var actSubmit = controller.addAction(new DBAction, "submit");

	actForm.action = function() {
		system.cache.setting.reload();
		outputer.outputForm(system.setting);
	}

	actSubmit.action = function() {
		this.withStringParam("siteName", true);
		this.withStringParam("siteURL", true);
		this.withStringParam("defaultLanguage", true);
		this.withBooleanParam("siteOpened");

		if (this.hasError) outputer.outputForm(this.form);
		else {
			system.setting.set(this.param);
			actForm.execute("submited");
		}
	}
}
%>
<%
function Main() {
	var actForm = controller.addAction(new FormAction);
	var actSubmit = controller.addAction(new DBAction, "submit");

	actForm.getSetting =
	actSubmit.getSetting = function() {
		var setting = new BlogSetting;
		setting.setSystemSource(system);
		setting.load();
		return setting;
	}

	actForm.action = function() {
		outputer.outputForm(this.getSetting());
	}

	actSubmit.action = function() {
		this.withStringParam("blogName", true);
		this.withStringParam("blogTitle");
		this.withStringParam("blogURL", true, 5);
		this.withStringParam("masterName", true);
		this.withEmailParam("masterEmail");
		if (this.hasError) outputer.outputForm(this.form);
		else {
			this.getSetting().update(this.param);
			actForm.execute();
		}
	}	
}
%>
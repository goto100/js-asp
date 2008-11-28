<%
function Main() {
	controller.checkPermission(system.user.getRight("administer"));

	var actList = controller.addAction(new Action);
	var actAdd = controller.addAction(new FormAction, "add");

	actList.action = function() {
		var applications = system.getApplications();
		applications.load();

		outputer.outputApplications(applications);
	}

	actAdd.action = function() {
		outputer.outputAddForm();
	}
}
%>
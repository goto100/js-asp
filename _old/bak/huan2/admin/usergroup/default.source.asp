<%
function Main() {
	controller.checkPermission(system.user.getRight("administer"));

	var actList = controller.addAction(new Action);
	var actAdd = controller.addAction(new FormAction, "add");
	var actEdit = controller.addAction(new FormAction, "edit");
	var actUpdate = controller.addAction(new DBAction, "update");

	actList.action = function() {
		system.cache.userGroups.reload();
		outputer.outputList(system.userGroups);
	}

	actAdd.action = function() {
		system.cache.userGroups.reload();
		outputer.outputAddForm(this.getValue(), system.userGroups);
	}

	actEdit.action = function() {
		var i, user, value;

		user = system.getUser(0, system.getUserGroup(this.getIdParam()));
		value = {
			id: user.group.id,
			name: user.group.name
		}
		for (i = 0; i < system.user.right.names.length; i++) value[system.user.right.names[i]] = user.getRight(system.user.right.names[i]);
		outputer.outputEditForm(value);
	}

	actUpdate.action = function() {
		var i, userGroup, user, right;

		this.withNumberParam("id", true);
		this.withStringParam("name", true);

		for (i = 0; i < system.user.right.names.length; i++) this.withBooleanParam(system.user.right.names[i]);

		if (this.hasError) outputer.outputEditForm(this.form);
		else {
			userGroup = system.getUserGroup(this.getIdParam());
			user = system.getUser(0, userGroup);
			user.load();
			right = {};
			for (i = 0; i < system.user.right.names.length; i++) right[system.user.right.names[i]] = this.param[system.user.right.names[i]],
			user.right.setPurview(right);
			userGroup.update({name: this.param.name,
				right: user.right.purview});
			actList.execute("updated");
		}
	}
}
%>
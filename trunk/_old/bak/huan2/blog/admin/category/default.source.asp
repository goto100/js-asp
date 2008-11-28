<%
function Main() {
	controller.checkPermission(system.user.getRight("administer"));

	var actTree = controller.addAction(new Action);
	var actUp = controller.addAction(new Action, "up");
	var actDown = controller.addAction(new Action, "down");
	var actAdd = controller.addAction(new FormAction, "add");
	var actSave = controller.addAction(new DBAction, "save");
	var actEdit = controller.addAction(new FormAction, "edit");
	var actUpdate = controller.addAction(new DBAction, "update");
	var actDelete = controller.addAction(new FormAction, "delete");

	actUp.action = function() {
		var category = system.getCategory(this.getIdParam());
		category.load();
		category.up()? actTree.execute("uped") : actTree.execute("alreadyTop");
	}

	actDown.action = function() {
		var category = system.getCategory(this.getIdParam());
		category.load();
		category.down()? actTree.execute("downed") : actTree.execute("alreadyBottom");
	}

	actDelete.action = function() {
		var category = system.getCategory(this.getIdParam());
		category.load();
		category.del();
		actTree.execute("category deleted");
	}

	actEdit.action = function() {
		var category = system.getCategory(this.getIdParam());
		category.load();

		outputer.outputEditForm(category);
	}

	actUpdate.action = function() {
		this.withNumberParam("id", true);
		this.withStringParam("name", true, 2);
		this.withStringParam("description");
		this.withNumberParam("articleCount", true);

		if (this.hasError) outputer.outputEditForm(this.form);
		else {
			var category = system.getCategory(this.getIdParam());
			category.load();
			category.update(this.param);
			actTree.execute("categoryUpdated");
		}
	}

	actAdd.action = function() {
		var category = system.getCategory();
		category.load(true);
		outputer.outputAddForm(this.getValue(), category);
	}

	actSave.action = function() {
		this.withStringParam("name", true, 2);
		this.withNumberParam("parentId", true);
		this.withStringParam("description");
		this.withStringParam("savedAction", "continueAdd", null, null, ["continueAdd", "list"]);

		var category = system.getCategory();
		category.load(true);
		if (this.hasError) outputer.outputAddForm(this.form, category);
		else {
			var category = system.getCategory();
			category.save(this.param);
			controller.msg = "categorySaved";
			if (this.param.savedAction == "continueAdd") {
				actAdd.value = this.param;
				actAdd.action();
			} else actTree.action();
		}
	}

	actTree.action = function() {
		var category = system.getCategory();
		category.load(true);

		outputer.outputTree(category);
	}
}
%>
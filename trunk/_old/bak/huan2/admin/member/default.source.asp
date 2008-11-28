<%
function Main() {
	controller.checkPermission(system.user.getRight("administer"));

	var actList = controller.addAction(new ListAction);
	var actAdd = controller.addAction(new FormAction, "add");
	var actSave = controller.addAction(new DBAction, "save");
	var actEdit = controller.addAction(new FormAction, "edit");
	var actUpdate = controller.addAction(new DBAction, "update");
	var actDelete = controller.addAction(new Action, "delete");

	actList.action = function() {
		var members = system.getMembers();
		members.setPage(this.getPageSize(20), this.getCurrentPage());
		members.orders = this.getOrders("regTime~,userId,nickname,lastVisitTime");
		members.keys = this.getKeys();
		members.load();
		outputer.outputMembers(members);
	}

	actAdd.action = function() {
		outputer.outputAddForm(this.getValue(), system.userGroups);
	}

	actSave.action = function() {
		this.withStringParam("userId", true);
		this.withNumberParam("groupId", true);
		this.withStringParam("password", true);
		this.withStringParam("rePassword", true, null, null, this.param.password);
		this.withStringParam("nickname");
		this.withStringParam("secQuestion", true);
		this.withStringParam("secAnswer", true);

		if (system.user.checkUserIdUsed(this.param.userId)) this.setParamError("userId", new Error(5, this.lang("userIdUsed")));
		if (this.hasError) outputer.outputAddForm(this.form);
		else {
			var user = system.getUser();
			user.save(this.param);
			actList.execute("membersSaved");
		}
	}

	actEdit.action = function() {
		var member = system.getUser(this.getIdParam());
		member.load();
		member.groupId = member.group.id;

		outputer.outputEditForm(member, system.userGroups);
	}

	actUpdate.action = function() {
		this.withNumberParam("id", true);
		this.withStringParam("userId", true);
		this.withStringParam("groupId", true);
		this.withStringParam("password");
		this.withStringParam("rePassword", false, null, null, this.param.password);
		this.withStringParam("nickname");
		this.withStringParam("secQuestion");
		this.withStringParam("secAnswer");

		var member = system.getUser(this.getIdParam());
		member.load();
		if (member.userId != this.param.userId && system.user.checkUserIdUsed(this.param.userId)) this.setParamError("userId", new Error(5, this.lang("userIdUsed")));
		if (this.hasError) outputer.outputEditForm(this.form, system.userGroups);
		else {
			member.update(this.param);
			actList.execute("memberUpdated");
		}
	}

	actDelete.action = function() {
		var member = system.getUser(this.getIdParam());
		member.del()
		actList.execute("memberDeleted");
	}
}
%>
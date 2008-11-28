<%
function Main() {
	controller.checkPermission(system.user.getRight("viewMembers"));

	var actList = controller.addAction(new ListAction);
	var actView = controller.addAction(new Action, "id");

	actList.action = function() {
		var members = system.getMembers();
		members.setPage(this.getPageSize(20), this.getCurrentPage());
		members.orders = this.getOrders("regTime~");
		members.load();
		outputer.outputMembers(members);
	}

	actView.action = function() {
		var member = system.getUser(this.getIdParam());
		if (!member.load()) controller.outputPage("badURL");
		else outputer.outputMember(member);
	}
}
%>
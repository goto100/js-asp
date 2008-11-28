<%
function Main() {
	controller.checkPermission(system.user.getRight("administer"));

	var actList = controller.addAction(new ListAction);
	var actClean = controller.addAction(new Action, "clean");

	actList.action = function() {
		var visitors = system.getVisitors();
		visitors.setPage(this.getPageSize(20), this.getCurrentPage());
		visitors.orders = this.getOrders("time~");
		visitors.load();
		outputer.outputList(visitors);
	}

	actClean.action = function() {
		system.getVisitors().clean();
		actList.execute("cleaned");
	}
}
%>
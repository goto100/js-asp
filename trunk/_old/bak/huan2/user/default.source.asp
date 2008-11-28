<%
function Main() {
	var actList = controller.addAction(new ListAction);

	actList.action = function() {
		var users = system.getUsers();
		users.load();
		outputer.outputUsers(users);
	}
}
%>
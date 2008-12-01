<!--#include file="../dao/UserDao.asp" -->
<script language="javascript" runat="server">
function UserListAction() {}
UserListAction.prototype = new ListAction();
var a = new ListAction();

UserListAction.prototype.action = function() {
	var dao = site.getUserDao();

	var users = dao.list(this.getPageSize(10), this.getCurrentPage());
	users.forEach(function(user) {
		writeln(user.username);
	});

form();

}



function AddUserAction() {};
AddUserAction.prototype = new FormAction();
AddUserAction.prototype.action = function() {
	write("add");
}

function EditUserAction() {};
EditUserAction.prototype = new FormAction();
EditUserAction.prototype.action = function() {
	write("edit");
}
</script>
<%
function form() {
%>
<form method="post" action="index.asp">
	<button name="delete" value="index.asp?1/1">É¾³ý</button>
	<input type="submit" />
	<input type="hidden" name="__method__" value="delete" />
</form>
<%
}
%>

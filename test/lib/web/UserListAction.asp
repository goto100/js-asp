<!--#include file="../../../src/web/ListAction.asp" -->
<!--#include file="../dao/UserDao.asp" -->
<script language="javascript" runat="server">
function UserListAction() {}
UserListAction.prototype = new ListAction();

UserListAction.prototype.action = function() {
	var dao = site.getUserDao();

	var users = dao.list(this.getPageSize(10), this.getCurrentPage());
	users.forEach(function(user) {
		writeln(user.username);
	});

write(this.request.method);
form();

}
</script>
<%
function form() {
%>
<form method="post" action="index.asp">
	<input type="submit" />
	<input type="hidden" name="__method__" value="delete" />
</form>
<%
}
%>

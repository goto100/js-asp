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

}
</script>

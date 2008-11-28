<!--#include file="../../../src/dao/Dao.asp" -->
<!--#include file="../pojos/User.asp" -->
<script language="javascript" runat="server">
function UserDao() {
	this.tableName = "Users";
}
UserDao.prototype = new Dao();

UserDao.prototype.toPojo = function(rec) {
	var user = new User();
	user.username = rec.get("username");
	return user;
}

UserDao.prototype.fromPojo = function(user) {
	return new Map({
		username: user.username,
		password: user.password
	});
}
</script>
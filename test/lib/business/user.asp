<script language="javascript" runat="server">
Site.prototype.getUserDao = function() {
	var dao = new UserDao();
	dao.db = this.db;
	return dao;
}

Site.prototype.getUsers = function(pageSize, currentPage) {
	var dao = this.getUserDao();
	return dao.list(pageSize, currentPage);
}
</script>
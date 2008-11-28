<script language="javascript" runat="server">
function HuanUsers(system) {
	List.call(this);

	this.ids = null;
	this.group = null;
	this.keys = null;

	this.load = function() {
		var sql = "SELECT m.id, m.userId, m.groupId, m.nickname, m.regTime, m.lastVisitTime, m.lastIP"
			+ " FROM " + system.db.USERS + " AS m, " + system.db.USER_GROUPS + " AS g"
			+ " WHERE m.groupId = g.id"
		if (this.ids) sql += " AND m.id IN (" + this.ids.join(", ") + ")";
		if (this.group) sql += " AND m.groupId = " + this.group.id;
		sql += this.getOrderSQL({userId: "m.userId",
			regTime: "m.regTime",
			nickname: "m.nickname",
			lastVisitTime: "m.lastVisitTime"});
		if (this.keys) for (var i = 0; i < this.keys.length; i++) sql += " AND m.userId LIKE '%" + this.keys[i] + "%'";

		var records = system.db.query(sql, this.pageSize, this.currentPage);
		if (!records) return;
		this.setRecords(records);
		for (var record; !records.atEnd(); records.moveNext()) {
			record = records.item();
			record.group =
			{
				id: record.groupId
			}
			delete record.groupId;
			this.push(record);
		}
	}
}
</script>
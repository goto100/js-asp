<script language="javascript" runat="server">
function HuanUsers(system) {
	List.apply(this);

	this.load = function() {
		var records = system.db.query("SELECT 0 AS id, NULL AS nickname, ip, visitTime"
			+ " FROM " + system.table.users
			+ " ORDER BY visitTime DESC"
			+ " UNION"
			+ " SELECT id, nickname, lastIp AS ip, visitTime"
			+ " FROM " + system.table.members
			+ " WHERE lastVisitTime > #" + system.db.checkDate(system.user.outlineTime) + "#"
			+ " AND visitTime IS NOT NULL"
			+ " ORDER BY visitTime DESC");
		if (records) for (var record; !records.atEnd(); records.moveNext()) {
			record = records.item();
			record.onlineTime = system.now - record.visitTime;
			this.push(record);
		}
	}
}
</script>
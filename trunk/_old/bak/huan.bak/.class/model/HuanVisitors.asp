<script language="javascript" runat="server">
function HuanVisitors(system) {
	List.call(this);

	this.load = function() {
		var records = system.db.query("SELECT 0 AS id, NULL AS nickname, ip, visitTime"
			+ " FROM " + system.db.VISITORS
			+ " ORDER BY visitTime DESC"
			+ " UNION"
			+ " SELECT id, nickname, lastIp AS ip, visitTime"
			+ " FROM " + system.db.USERS
			+ " WHERE lastVisitTime > #" + DBAccess.checkDate(system.user.outlineTime) + "#"
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
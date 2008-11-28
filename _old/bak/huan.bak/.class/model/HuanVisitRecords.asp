<script language="javascript" runat="server">
function HuanVisitors(system) {
	List.call(this);

	this.load = function() {
		var sql = "SELECT ip, time, os, browser, referer, target FROM " + system.db.VISIT_RECORDS
		sql += this.getOrderSQL({ip: "ip",
			time: "time",
			os: "os",
			browser: "browser",
			referer: "referer",
			target: "target"});
		var records = system.db.query(sql, this.pageSize, this.currentPage);
		if (!records) return;
		this.setRecords(records);
		for (var record; !records.atEnd(); records.moveNext()) {
			record = records.item();
			this.push(record);
		}
	}

	this.clean = function() {
		system.db.del(system.db.VISIT_RECORDS);
	}
}
</script>
<script language="javascript" runat="server">
function HuanUserGroups(system) {
	List.apply(this);

	this.load = function() {
		var sql = "SELECT id, name, right, userCount"
			+ " FROM " + system.table.userGroups;
		var records = system.db.query(sql);
		if (!records) return false;
		else this.fill(records);
	}

	this.fill = function(records) {
		if (records.constructor == VBArray) for (var i = 0; i <= records.ubound(2); i++) this.push({id: records.getItem(0, i),
			name: records.getItem(1, i),
			right: records.getItem(2, i)});
		else {
			for (var record; !records.atEnd(); records.moveNext()) {
				record = records.item();
				this.push(record);
			}
		}
	}

	this.getVbArr = function() {
		return system.db.query("SELECT id, name, right FROM " + system.table.userGroups, null, null, true);
	}
}
</script>
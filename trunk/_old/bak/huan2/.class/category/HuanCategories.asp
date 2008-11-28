<script language="javascript" runat="server">
function HuanCategories(ids) {
	List.apply(this);

	var system;
	var tblCategories;

	this.setSystemSource = function(huanSystem) {
		system = huanSystem;
		tblCategories = system.dbName("Categories");
	}

	this.load = function() {
		var sql = "SELECT id, name, url, parentId, lFlag, rFlag"
			+ " FROM " + tblCategories
			+ " WHERE id IN (" + ids.join(", ") + ")"
			+ " ORDER BY lFlag";

		var records = system.db.query(sql);
		if (!records) throw new Error(0);
		ids = [];
		for (var record; !records.atEnd(); records.moveNext()) {
			record = records.item();
			ids.push(record.id);
			this.push(record);
		}
		return ids;
	}
}
</script>
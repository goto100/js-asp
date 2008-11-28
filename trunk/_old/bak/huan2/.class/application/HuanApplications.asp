<script language="javascript" runat="server">
function HuanApplications(system) {
	List.apply(this);

	this.load = function() {
		var records = system.db.query("SELECT id, path FROM " + system.table.applications);
		if (!records) throw new Error(0);

		for (var record; !records.atEnd(); records.moveNext()) this.push(records.item());
	}
}
</script>
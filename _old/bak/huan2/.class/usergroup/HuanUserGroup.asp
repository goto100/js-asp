<script language="javascript" runat="server">
function HuanUserGroup(system) {
	this.id = 0;
	this.name = "";
	this.userCount = 0;
	this.right = 0;

	this.update = function(value) {
		if (value) this.fill(value);
		system.db.update(system.table.userGroups, {name: this.name,
			right: this.right}, "id = " + this.id);
	}

	this.fill = function(record) {
		this.name = record.name;
		this.right = record.right;
	}
}
</script>
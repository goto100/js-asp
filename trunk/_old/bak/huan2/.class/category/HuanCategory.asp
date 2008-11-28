<script language="javascript" runat="server">
function HuanCategory(system) {
	Category.apply(this);

	this.setDBSource(system.db);
	this.setTableName(system.table.categories);

	this.name = "";
	this.url = "";

	this.setLoadItems("name", "url");

	this.fillSaveItem =
	this.fillUpdateItem = function(item) {
		item.name = this.name;
		item.url = this.url;
	}

	this.fillCategory = function(record) {
		this.name = record.name;
		this.url = record.url;
	}
}
</script>
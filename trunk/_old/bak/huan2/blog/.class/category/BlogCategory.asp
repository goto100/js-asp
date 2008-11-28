<script language="javascript" runat="server">
function BlogCategory(id) {
	Category.apply(this, [id]);

	var system;
	var tblCategories;

	this.name = "";
	this.description = "";
	this.articleCount = 0;

	this.setSystemSource = function(sys) {
		system = sys;
		tblCategories = system.dbName("Categories");
		this.setDBSource(system.db);
		this.setTableName(system.dbName("Categories"));
	}

	this.setLoadItems("name", "description", "articleCount");

	this.fillSaveItem =
	this.fillUpdateItem = function(item) {
		item.name = this.name;
		item.description = this.description;
		item.articleCount = this.articleCount;
	}

	this.fillCategory = function(record) {
		this.name = record.name;
		this.description = record.description;
		this.articleCount = record.articleCount;
	}
}
</script>
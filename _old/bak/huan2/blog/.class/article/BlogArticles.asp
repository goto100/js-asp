<script language="javascript" runat="server">
function BlogArticles() {
	List.apply(this);

	var system;
	var tblArticles;
	var tblCategories;

	this.category = null;

	this.setSystemSource = function(blogSystem) {
		system = blogSystem;
		tblArticles = system.dbName("Articles");
		tblCategories = system.dbName("Categories");
	}

	this.load = function() {
		var record, sql = "SELECT a.id, a.title, a.content, a.postTime, c.id AS cateId, c.name AS cateName"
			+ " FROM " + tblArticles + " AS a, " + tblCategories + " AS c"
			+ " WHERE a.cateId = c.id";
		if (this.ids) sql += " AND m.id IN (" + this.ids.join(", ") + ")";
		if (this.category) sql += " AND a.cateId = " + this.category.id;
		sql += this.getOrderSQL({postTime: "a.postTime",
			title: "a.title",
			category: "c.name"});
		var records = system.db.query(sql, this.pageSize, this.currentPage);
		if (!records) return;
		if (this.category) this.category.name = records.item().cateName;
		this.setRecords(records);
		for (; !records.atEnd(); records.moveNext()) {
			record = records.item();
			record.category = {
				id: record.cateId,
				name: record.cateName
			}
			delete record.cateId, record.cateName;
			this.push(record);
		}
	}
}
</script>
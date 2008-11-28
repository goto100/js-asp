<script language="javascript" runat="server">
function BlogArticle(id) {
	var system;
	var tblArticles;
	var tblCategories;

	this.id = id || 0;
	this.title = "";
	this.category = null;
	this.postTime = null;
	this.content = "";

	this.setSystemSource = function(blogSystem) {
		system = blogSystem;
		tblArticles = system.dbName("Articles");
		tblCategories = system.dbName("Categories");
	}

	this.load = function() {
		var record;

		record = system.db.query("SELECT a.id, a.title, a.postTime, a.content, c.id AS cateId, c.name AS cateName"
			+ " FROM " + tblArticles + " AS a, " + tblCategories + " AS c"
			+ " WHERE a.id = " + this.id
			+ " AND a.cateId = c.id", 1);
		this.id = record.id;
		this.title = record.title;
		this.postTime = record.postTime;
		this.content = record.content;
		this.category = {
			id: record.cateId,
			name: record.cateName
		}
		delete record.cateId, record.cateName;
	}

	this.save = function(value) {
		var record;

		if (value) this.fill(value);

		record = system.db.insert(tblArticles, {cateId: this.category.id,
			title: this.title,
			content: this.content}, true);
		this.fill(record);
	}

	this.update = function(value) {
		if (value) this.fill(value);

		system.db.update(tblArticles, {cateId: this.category.id,
			title: this.title,
			postTime: this.postTime,
			content: this.content}, "id = " + this.id);
	}

	this.fill = function(record) {
		this.id = record.id;
		this.title = record.title;
		this.postTime = record.postTime;
		this.content = record.content;
		this.category = {
			id: record.cateId,
			name: record.cateName
		}
	}
}
</script>
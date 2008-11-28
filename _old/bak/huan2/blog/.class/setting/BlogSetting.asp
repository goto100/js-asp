<script language="javascript" runat="server">
function BlogSetting() {
	var system;

	this.blogName = "";
	this.blogTitle = "";
	this.blogURL = "";
	this.masterName = "";
	this.masterEmail = "";

	this.setSystemSource = function(blogSystem) {
		system = blogSystem;
	}

	this.fill = function(record) {
		this.blogName = record.blogName;
		this.blogTitle = record.blogTitle;
		this.blogURL = record.blogURL;
		this.masterName = record.masterName;
		this.masterEmail = record.masterEmail;
	}

	this.load = function() {
		var record = system.db.query("SELECT * FROM [blog_Settings]", 1);
		this.fill(record);
	}

	this.update = function(value) {
		if (value) this.fill(value);

		system.db.update("blog_Settings", {blogName: this.blogName,
			blogTitle: this.blogTitle,
			blogURL: this.blogURL,
			masterName: this.masterName,
			masterEmail: this.masterEmail});
	}
}
</script>
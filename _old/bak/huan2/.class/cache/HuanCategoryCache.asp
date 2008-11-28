<script language="javascript" runat="server">
function HuanCategoryCache() {
	this.build = function(path) {
		var page = new Page("category");
		page.contentType = "xml";
		page.build(path);
	}
}
</script>
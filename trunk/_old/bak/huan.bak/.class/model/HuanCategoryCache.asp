<script language="javascript" runat="server">
function HuanCategoryCache() {
	this.build = function(path) {
		var view = new View("category");
		view.contentType = View.XML;
		view.build(path);
	}
}
</script>
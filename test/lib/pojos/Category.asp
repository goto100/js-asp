<script language="javascript" runat="server">
function Category(id) {
	this.id = id || 0;
	this.parentCategory = null;
	this.isLeaf = false;
	this.length = 0;
	this.depth = 0;
}

Category.prototype = new Array();

Category.prototype.getArticles = function() {
	
}
</script>
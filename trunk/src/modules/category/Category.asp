<script language="javascript" runat="server">
function Category(id) {
	this.id = id || 0;
	this.parent = null;
	this.depth = 0;
	this.length = 0;
}

Category.prototype.push = function(category) {
	category.parent = this;
	if (this.id) category.depth = this.depth + 1; // root depth is null, root children depth is 0.
	this[this.length++] = category;
}

Category.prototype.forEach = function(callback) {
	for (var i = 0; i < this.length; i++) {
		callback(this[i], i);
	}
}
</script>
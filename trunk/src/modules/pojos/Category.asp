<script language="javascript" runat="server">
function Category(id) {
	this.id = id || 0;
	this.parent = null;
	this.isLeaf = false;
	this.length = 0;
	this.depth = 0;
	this.lFlag;
	this.rFlag;

}
Category.prototype = new Array();

Category.prototype.appendNode = function(node) {
	this[this.length++] = node;
}

Category.prototype.clear = function() {
	for (; this.length; this.length--) delete this[this.length];
}

</script>
<script language="javascript" runat="server">
function Page() {
	this.id = "";
	this.styles = [];
	this.scripts = [];
	this.template = {};
}

Page.prototype.show = function(name) {
	this.template[name].apply(this, Array.slice(arguments, 1));
}

Page.prototype.output = function() {

}

Page.prototype.build = function(path) {
	
}

</script>
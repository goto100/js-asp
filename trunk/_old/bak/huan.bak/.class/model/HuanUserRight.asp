<script language="javascript" runat="server">
function HuanUserRight(purview) {
	UserRight.call(this, purview);

	this.add("viewSite");
	this.add("administer");
	this.add("viewUsers");
	this.add("viewVisitors");
}
</script>
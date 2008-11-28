<script language="javascript" runat="server">
function HuanUserRight(purview) {
	UserRight.apply(this, [purview]);

	this.add("viewSite");
	this.add("administer");
	this.add("viewMembers");
	this.add("viewUsers");
}
</script>
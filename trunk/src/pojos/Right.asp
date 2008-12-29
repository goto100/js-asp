<script language="javascript" runat="server">
function Right() {}

Right.prototype.p = function(value) {
	return Math.pow(2, value);
}

Right.prototype.checkPurview = function(purview, value) {
	return (purview & value) == value;
}

</script>
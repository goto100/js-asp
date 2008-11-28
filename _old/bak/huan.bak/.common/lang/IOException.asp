<script language="javascript" runat="server">
function IOException(message) {

	this.getMessage = function() {
		return message;
	}
}
</script>
<!--#include file="../../../src/db/DBAccess.asp" -->
<script language="javascript" runat="server">
function Site() {
	this.db = null;
}

Site.prototype.load = function() {
	this.db = new DBAccess();
	this.db.dbPath = MAIN_DB_PATH;
	this.db.prefix = "js";
	this.db.open();
}

</script>
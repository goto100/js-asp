<script language="javascript" runat="server">
function HuanController()
{
	Controller.call(this);

	// Initialization
	Response.Buffer = true;
	Server.ScriptTimeOut = 90;
	
	Session.LCID = 2048;
	// Session.LCID = 2057;
	
	Session.CodePage = 65001;
	// Session.CodePage = 936;
	
	// Response.Charset = "utf-8";
	Response.Charset = "gb2312";
}
</script>
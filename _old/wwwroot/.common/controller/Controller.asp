<script language="javascript" runat="server">
function Controller()
{
	this.addActionClass = function(ActionClass)
	{
		ActivedActionClass = ActionClass;
	}

	this.main = function()
	{
		var action = new ActivedActionClass();
		action.main();
	}

	var ActivedActionClass;
}
</script>
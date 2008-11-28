<script language="javascript" runat="server">
function Action()
{
	this.view = null;

	this.setView = function(view)
	{
		this.view = view;
	}

	this.main = function()
	{
		if (this.beforeFliter && !this.beforeFliter())
			return;
		if (this.validate)
		{
			var errors = this.validate();
			if (errors.length)
				this.invalidate();
			else
				this.execute()
		}
		else this.execute();
		if (this.afterFliter && !this.afterFliter())
			return;
	}
}
</script>
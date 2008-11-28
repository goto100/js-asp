<script language="javascript" runat="server">
function LoginFormView(value)
{
	FormView.call(this, "login", value);

	this.setForm(
	{
		login: ["userId", "password", "rePassword", "remState"]
	});
}
</script>
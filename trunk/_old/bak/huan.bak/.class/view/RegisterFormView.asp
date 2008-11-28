<script language="javascript" runat="server">
function RegisterFormView(value)
{
	FormView.call(this, "register", value);

	this.setForm(
	{
		register: ["userId", "password", "rePassword", "gender"]
	});
}
</script>
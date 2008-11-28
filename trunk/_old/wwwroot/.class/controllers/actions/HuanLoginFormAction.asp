<script language="javascript" runat="server">
function HuanLoginFormAction()
{
	FormAction.call(this);

	this.setView(new FormView("form"));
	this.view.setChild(
	{
		user:
		{
			userId: null,
			password: "aaa",
			rePassword: null
		},
		user2:
		{
			$abc: "abc",
			abc: "abc"
		},
		$foo: "test"
	});
	this.view.output();
}
</script>
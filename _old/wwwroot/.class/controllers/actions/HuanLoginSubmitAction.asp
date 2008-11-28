<script language="javascript" runat="server">
function HuanLoginSubmitAction()
{
	SubmitAction.call(this);

	this.beforeFliter = function()
	{
		if (this.visitor.loggedIn)
		{
			this.outputPage("alreadyLoggedIn");
			return false;
		}
	}

	this.validate = function()
	{
		this.withStringParam("user.userId", true);
		this.withStringParam("user.password", true);
		this.withStringParam("user.rePassword", true, null, null, this.param.password);
		this.withBooleanParam("login.remState");
		try
		{
			this.visitor.login(this.param.userId, system.encode(this.param.password));
		}
		catch(e)
		{
			if (e.constructor == HuanUserLoginUserIdEmptyException)
			{
				e.description = this.lang("userIdEmpty");
				this.setParamError("userId", e);
			}
			else if (e.constructor == HuanUserLoginWrongPasswordException)
			{
				e.description = this.lang("passwordWrong");
				this.setParamError("password", e);
			}
		}
	}

	this.invalidate = function()
	{
		this.getPage(new LoginFormView(this.form)).output();
	}

	this.execute = function()
	{
		var eDate;
		if (this.param.remState)
		{
			eDate = new Date(system.now);
			eDate.setYear(eDate.getYear() + 1);
		}
		this.setCookie("userLoggedIn", true, eDate);
		this.setCookie("userId", this.visitor.id, eDate);
		this.setCookie("userPassword", this.visitor.password, eDate);

		this.outputPage("loggedIn");
	}
}
</script>
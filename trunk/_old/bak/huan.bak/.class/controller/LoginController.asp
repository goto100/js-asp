<script language="javascript" runat="server">
function LoginController()
{
	HuanController.call(this);

	var system = new HuanSystem(MAIN_DB_PATH);
	system.load();


	this.addAction(new LoginFormAction);
	this.addAction(new LoginSubmitAction, "submit");

	function LoginFormAction()
	{
		FormAction.call(this);

		this.action = function()
		{
			if (this.visitor.loggedIn)
				this.outputPage("alreadyLoggedIn");
			else
				this.getPage(new LoginFormView(this.getValue("userId"))).output();
		}
	}

	function LoginSubmitAction()
	{
		SubmitAction.call(this);

		this.validate = function()
		{
			
		}

		this.action = function()
		{
			if (this.visitor.loggedIn)
				this.outputPage("alreadyLoggedIn");
			else
			{
				this.withStringParam("userId", true);
				this.withStringParam("password", true);
				this.withStringParam("rePassword", true, null, null, this.param.password);
				this.withBooleanParam("remState");

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
				if (this.hasError)
					this.getPage(new LoginFormView(this.form)).output();
				else
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
		}
	}
}
</script>
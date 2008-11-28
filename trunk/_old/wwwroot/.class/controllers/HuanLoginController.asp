<!--#include file="actions/HuanLoginFormAction.asp" -->
<!--#include file="actions/HuanLoginSubmitAction.asp" -->
<script language="javascript" runat="server">
function HuanLoginController()
{
	HuanController.call(this);

	this.addActionClass(HuanLoginFormAction);
	this.addActionClass(HuanLoginSubmitAction);
}
</script>
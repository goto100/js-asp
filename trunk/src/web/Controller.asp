<!--#include file="UploaderFile.asp" -->
<!--#include file="HttpRequest.asp" -->
<script language="javascript" runat="server">
function Controller() {
	this.request = new HttpRequest();
	this.ActivedActionClass;
}
Controller.prototype.addActionClass = function(ActionClass, actived) {
	if (actived === true || this.request.search[0].contains(actived)) this.ActivedActionClass = ActionClass;
}

Controller.prototype.execute = function() {
	if (this.ActivedActionClass) {
		var action = new this.ActivedActionClass();
		action.setController(this);
		action.execute();
	}
}
</script>
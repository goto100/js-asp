<!--#include file="UploaderFile.asp" -->
<!--#include file="HttpRequest.asp" -->
<script language="javascript" runat="server">
function Controller() {
	this.request = new HttpRequest();
	this.ActivedAction;
}
Controller.prototype.addActionClass = function(ActionClass, actived) {
	if (actived === true || this.request.search[0].contains(actived)) this.ActivedAction = ActionClass;
}

Controller.prototype.execute = function() {
	if (this.ActivedAction) {
		var action = new this.ActivedAction();
		action.setController(this);
		action.execute();
	}
}
</script>
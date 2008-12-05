<!--#include file="UploaderFile.asp" -->
<!--#include file="HttpRequest.asp" -->
<!--#include file="Action.asp" -->
<!--#include file="FormAction.asp" -->
<!--#include file="SubmissionAction.asp" -->
<!--#include file="ListAction.asp" -->
<script language="javascript" runat="server">
function Controller() {
	this.request = new HttpRequest();
	this.ActivedAction;
}

Controller.prototype.addActionClass = function(ActionClass, actived) {
	if (actived === true || this.dispatch(ActionClass)) {
		this.ActivedAction = ActionClass;
	}
}

Controller.prototype.execute = function() {
	if (this.ActivedAction) {
		var action = new this.ActivedAction();
		action.setController(this);
		action.execute();
	}
}

Controller.prototype.dispatch = function(ActionClass) {
	if (instanceOf(ActionClass.prototype, ListAction)) return true;
	return false;
}

</script>
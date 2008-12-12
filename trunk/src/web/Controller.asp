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
	if (this.dispatch(actived)) {
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

Controller.prototype.dispatch = function(actived) {
	switch (actived) {
		case "list":
			if (this.request.method == "GET" && !this.request.search.path) return true;
			break;
		case "show":
			if (this.request.method == "GET" && this.request.search.path) return true;
			break;
		case "new":
			if (this.request.method == "GET" && ["new", "post", "create"].contains(this.request.search.path)) return true;
			break;
		case "edit":
			if (this.request.method == "GET" && ["new", "post", "create"].contains(this.request.search.path)) return true;
			break;
		case "save":
			if (this.request.method == "PUT") return true;
			break;
		case "update":
			if (this.request.method == "POST" && this.request.search.path) return true;
			break;
		case "delete":
			if (this.request.method == "DELETE" && this.request.search.path) return true;
			break;
	}
}

</script>
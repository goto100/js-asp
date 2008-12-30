<!--#include file="HttpRequest.asp" -->
<!--#include file="Action.asp" -->
<!--#include file="FormAction.asp" -->
<!--#include file="PostAction.asp" -->
<!--#include file="ListAction.asp" -->
<script language="javascript" runat="server">
function Controller() {
	this.request = new HttpRequest();
	this.actions = [];
}

Controller.prototype.add = function(path, ActionClass) {
	if (!ActionClass) ActionClass = Action;
	var action = new ActionClass();
	action.setController(this);
	action.path = path;
	if (typeof action.path == "string") action.path = action.path.split("/");
	this.actions.push(action);
	return action;
}

Controller.prototype.execute = function() {
	var path = this.request.search.path;
	var method = this.request.method;
	
	this.actions.forEach(function(action) {
		if (action.path instanceof RegExp) {
			if (path && action.path.test(path)) {
				action.action();
			}
		} else if (action.path instanceof Array) {
			if (path && action.path.length == path.length && action.path.every(function(p, i) {
				return path[i]? new RegExp(p, "ig").test(path[i]) : false;
			})) {
				action.action();
			}
		}
	});
}

</script>
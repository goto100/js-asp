<!--#include file="HttpRequest.asp" -->
<!--#include file="Action.asp" -->
<!--#include file="FormAction.asp" -->
<!--#include file="SubmissionAction.asp" -->
<!--#include file="ListAction.asp" -->
<script language="javascript" runat="server">
function Controller() {
	this.request = new HttpRequest();
	this.path = new Map();
}

Controller.prototype.add = function(pattern, Action) {
	var path = {
		doGet: null,
		doPost: null,
		doPut: null,
		doHead: null,
		doDelete: null
	};
	this.path.put(pattern, path);
	return path;
}

Controller.prototype.execute = function() {
	var path = this.request.search.path.toString();
	var method = this.request.method;
	this.path.forEach(function(value, key) {
		if (path.match(new RegExp("^" + key + "", "ig"))) {
			var func = value["do" + method.slice(0, 1) + method.slice(1).toLowerCase()];
			if (func) func();
		}
	});
}

</script>
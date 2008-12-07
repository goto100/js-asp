<!--#include file="Uploader.asp" -->
<script language="javascript" runat="server">
function HttpRequest() {
	this.search = getSearch();
	this.input = getInput();

	this.method = this.input["__method__"]? this.input["__method__"].toUpperCase() : "GET";
	if (!["GET", "POST", "PUT", "DELETE", "HEAD"].contains(this.method)) {
		this.method = Request.ServerVariables("REQUEST_METHOD");
	}

	this.path = String(Request.ServerVariables("PATH_INFO"));
	this._ip;

	// Request.Form
	function getInput() {
		var input = {}
		if (String(Request.ServerVariables("CONTENT_TYPE")).substr(0, 19) == "multipart/form-data") {
			var uploader = new Uploader();
			input = uploader.getInput();
		} else {
			var name;
			var e = new Enumerator(Request.Form);
			for (var i = 0; !e.atEnd(); e.moveNext(), i++) {
				name = String(e.item());
				input[i] = input[name] = String(Request.Form(name));
			}
		}
		return input;
	}

	// Request.QueryString
	function getSearch() {
		var queryString = String(Request.QueryString);
		var search = queryString.split("&");
		if (search[0].indexOf("=") == -1) search[0] = search[0].split("/");
		else search.unshift(null);
		for (var i = 1/* Ignore path */; i < search.length; i++) {
			search[i] = new String(search[i]);
			search[i].name = search[i].substr(0, search[i].indexOf("="));
			search[i].valueOf = function() {
				return this.substr(this.indexOf("=") + 1);
			}
			search[search[i].name] = search[i];
		}
		return search;
	}
}

HttpRequest.prototype.getIP = function() {
	if (this._ip) return this._ip;
	this._ip = String(Request.ServerVariables("HTTP_X_FORWARDED_FOR")).replace(/[^0-9\.,]/g, "");
	if (this._ip.length < 7) this._ip = String(Request.ServerVariables("REMOTE_ADDR")).replace(/[^0-9\.,]/g, "");
	if (this._ip.indexOf(",") > 7) this._ip = this._ip.substr(0, this._ip.indexOf(","));
	return this._ip;
}
</script>
<!--#include file="Uploader.asp" -->
<script language="javascript" runat="server">
function HttpRequest() {
	this.search = getSearch();
	this.input = getInput();

	this.method = Request.ServerVariables("REQUEST_METHOD");
	var methodOverwrite = this.input.get("__method__");
	if (methodOverwrite) methodOverwrite = methodOverwrite.toUpperCase();
	if (["GET", "POST", "PUT", "DELETE", "HEAD"].contains(methodOverwrite)) this.method = methodOverwrite;

	this.path = String(Request.ServerVariables("PATH_INFO"));
	this._ip;

	// Request.Form
	function getInput() {
		var input = new Map();
		if (String(Request.ServerVariables("CONTENT_TYPE")).substring(0, 19) == "multipart/form-data") {
			var uploader = new Uploader();
			var items = uploader.getItems();
			for (var i = 0; i < items.length; i++) {
				var item = items[i];
				if (instanceOf(item.value, UploaderFile)) {
					if (!this.input.get(item.name)) this.input.put(item.name, []);
					if (item.value.name) this.input.get(item.name).push(item.value);
				} else {
					if (!this.input.get(item.name)) this.input.put(item.name, item.value);
					else this.input.put(item.name, this.input.get(item.name) += ", " + item.value);
				}
			}
		} else {
			var name;
			var e = new Enumerator(Request.Form);
			for (var i = 0; !e.atEnd(); e.moveNext(), i++) {
				name = String(e.item());
				input.put(name, String(Request.Form(name)));
			}
		}
		return input;
	}

	// Request.QueryString
	function getSearch() {
		var queryString = String(Request.QueryString);
		var searches = queryString.split("&");
		var search = new Map();
		if (searches[0] && searches[0].indexOf("=") == -1) {
			search.path = searches[0].split("/");
			search.path = search.path.filter(function(part) {
				if (part) return true;
			});
			search.path.toString = function() {
				return this.join("/");
			}
		}
		for (var item, pos, i = 1/* Ignore path */; i < searches.length; i++) {
			pos = searches[i].indexOf("=");
			item = {
				name: searches[i].substr(0, pos),
				value: searches[i].substr(pos + 1)
			}
			var value = search.get(item.name) || [];
			value.push(item.value);
			search.put(item.name, value);
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
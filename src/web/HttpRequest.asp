<!--#include file="Uploader.asp" -->
<script language="javascript" runat="server">
function HttpRequest() {
	this.search = getSearch();
	this.input = getInput();
	this.uploadPath;

	this.method = Request.ServerVariables("REQUEST_METHOD");
	var methodOverwrite = this.input.get("__method__");
	if (methodOverwrite) methodOverwrite = methodOverwrite[0].toUpperCase();
	if (["GET", "POST", "PUT", "DELETE", "HEAD"].contains(methodOverwrite)) this.method = methodOverwrite;

	this.path = String(Request.ServerVariables("PATH_INFO"));
	this._ip;

	function stringToMap(str) {
		var maps = str.split("&");
		var map = new Map();
		if (maps[0] && maps[0].indexOf("=") == -1) {
			map.path = maps[0].split(/\/+/ig);
			map.path.toString = function() {
				return this.join("/");
			}
			maps = maps.splice(0, 1);
		}
		for (var item, pos, i = 0; i < maps.length; i++) {
			pos = maps[i].indexOf("=");
			item = {
				name: maps[i].substr(0, pos),
				value: decodeURI(maps[i].substr(pos + 1))
			}
			var value = map.get(item.name) || [];
			value.push(item.value);
			map.put(item.name, value);
		}
		return map;
	}

	// Request.Form
	function getInput() {
		var input = new Map();
		if (String(Request.ServerVariables("CONTENT_TYPE")).substring(0, 19) == "multipart/form-data") {
			var uploader = new Uploader();
			var items = uploader.getItems();
			for (var i = 0; i < items.length; i++) {
				var item = items[i];
				if (item.value instanceof UploaderFile) {
					if (!input.get(item.name)) input.put(item.name, []);
					if (item.value.name) input.get(item.name).push(item.value);
				} else {
					if (!input.get(item.name)) input.put(item.name, item.value);
					else input.put(item.name, input.get(item.name) += ", " + item.value);
				}
			}
			return input;
		} else return stringToMap(String(Request.Form));
	}

	// Request.QueryString
	function getSearch() {
		return stringToMap(String(Request.QueryString));
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
<!--#include file="HttpRequest.asp" -->
<script language="javascript" runat="server">
function Controller(pathDepth)
{
	this.activedAction = null;

	this.request = new HttpRequest();

	this.name = "";
	this.pathDepth = pathDepth || 0;
	this.rootPath = "";
	this.pageName = "";
	this.pageSkin = "default";
	this.contentType = View.XML;
	this.fillAction = null;
	this.msg = null;
	this.pageCotnentType = View.XML;

	// Transform path to absolute
	function transformToAbsolutePath(path)
	{
		if (path.substr(0, 1) == "/") return path.slice(0, path.lastIndexOf("/") + 1);
		return pathInfo.substr(0, pathInfo.lastIndexOf("/") + 1) + path;
	}

	// Transform path
	function transformPath(pathA, pathB)
	{
		if (!pathB) pathB = "";
		var i, l, result = "", arrB, arrA, pathBName = pathB.substr(pathB.lastIndexOf("/") + 1);

		pathA = transformToAbsolutePath(pathA);
		pathB = transformToAbsolutePath(pathB);
		arrB = pathB.split("/");
		arrA = pathA.split("/");
		l = arrA.length;
		for (i = 0; i < arrA.length; i++) if (arrA[i] != arrB[i]) {
			l = i;
			break;
		}
		for (i = 0; i < arrA.length - l; i++) if (arrA[i]) result += "../";
		for (i = l; i < arrB.length; i++) if (arrB[i]) result += arrB[i] + "/";

		return result + pathBName;
	}

	function getAbsolutePath(path, depth)
	{
		var i, absolutePath = "/";
		var pathInfoArr = path.substr(1).split("/").slice(0, depth);
		for (i = 0; i < depth; i++) absolutePath += pathInfoArr[i] + "/";
		return absolutePath;
	}

	this.getCookie = function(name)
	{
		var cookie = String(Request.Cookies(NAME_SPACE)(name));
		return cookie == "undefined"? null : cookie;
	}

	this.setCookie = function(name, value, expiresDate)
	{
		Response.Cookies(NAME_SPACE)(name) = value;
		if (expiresDate) Response.Cookies(NAME_SPACE).Expires = expiresDate.getVarDate();
	}

	this.removeCookie = function(name)
	{
		Response.Cookies(NAME_SPACE)(name) = "";
	}

	this.addAction = function(action, actived)
	{
		if ((actived == true) || (this.request.search[0] == actived) || (actived == null && this.request.search[this.request.search[0]] != null)) this.activedAction = action;
		action.controller = this;
		action.search = this.request.search;
		action.input = this.request.input;
		if (this.fillAction) this.fillAction(action);

		return action;
	}

	this.checkPermission = function(hasPermission)
	{
		if (!hasPermission) this.outputPage("noPermission");
	}

	this.outputPage = function(root, content)
	{
		if (!content) content = this.lang(root);
		var page = this.getPage(new View(root));
		view.content.setContent(content);
		view.output();
		Response.End();
	}
	
	this.main = function()
	{
		if (this.activedAction) this.activedAction.action();
		else this.outputPage("badURL");
		Response.End();
	}

	this.load = function()
	{
		var path = transformPath(getAbsolutePath(this.request.path, this.pathDepth), this.request.path);
		this.rootPath = transformPath(this.request.path, getAbsolutePath(this.request.path, PATH_DEPTH));
		this.pageName = path.substring(0, path.lastIndexOf("/") + 1) + this.request.path.substring(this.request.path.lastIndexOf("/") + 1, this.request.path.lastIndexOf(".")).toLowerCase();
	}
}
</script>
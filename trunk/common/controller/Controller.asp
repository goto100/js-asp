<!--#include file="UploaderFile.asp" -->
<!--#include file="HttpRequest.asp" -->
<script language="javascript" runat="server">
function Controller(pathDepth) {
	var lang;

	this.activedAction = null;

	this.request = new HttpRequest;

	this.name = "";
	this.visitor = null;
	this.pathDepth = pathDepth || 0;
	this.rootPath = "";
	this.pageName = "";
	this.pageSkin = "default";
	this.contentType = "xml";
	this.fillAction = null;
	this.msg = null;
	this.pageCotnentType = "xml";

	// Get language
	function getLangs(requestPath, filePath, pageName) {
		var i, j, eleLangs, attPage, file = Server.MapPath(filePath), fileName = requestPath.slice(0, -1), domLang = new XMLDom;

		if (fileName.indexOf("/") != -1) fileName = fileName.slice(0, fileName.indexOf("/"));
		domLang.load(file);
		if (!domLang.documentElement) return {};

		var lang = {}
		var eleItems = domLang.documentElement.getElementsByTagName("items");
		for (i = 0; i < eleItems.length; i++) {
			attPage = eleItems[i].getAttribute("page");
			if (attPage == pageName || attPage == "common") {
				eleLangs = eleItems[i].getElementsByTagName("item");
				for (j = 0; j < eleLangs.length; j++) lang[eleLangs[j].getAttribute("id")] = eleLangs[j].text;
			}
		}
		return lang;
	}

	// Transform path to absolute
	function transformToAbsolutePath(path) {
		if (path.substr(0, 1) == "/") return path.slice(0, path.lastIndexOf("/") + 1);
		return pathInfo.substr(0, pathInfo.lastIndexOf("/") + 1) + path;
	}

	// Transform path
	function transformPath(pathA, pathB) {
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

	function getAbsolutePath(path, depth) {
		var i, absolutePath = "/";
		var pathInfoArr = path.substr(1).split("/").slice(0, depth);
		for (i = 0; i < depth; i++) absolutePath += pathInfoArr[i] + "/";
		return absolutePath;
	}

	this.lang = function(key) {
		return lang[key] || key;
	}

	this.getCookie = function(name) {
		var cookie = String(Request.Cookies(NAME_SPACE)(name));
		return cookie == "undefined"? null : cookie;
	}

	this.setCookie = function(name, value, expiresDate) {
		Response.Cookies(NAME_SPACE)(name) = value;
		if (expiresDate) Response.Cookies(NAME_SPACE).Expires = expiresDate.getVarDate();
	}

	this.removeCookie = function(name) {
		Response.Cookies(NAME_SPACE)(name) = "";
	}

	this.addAction = function(action, actived) {
		if ((actived == true) || (this.request.search[0] == actived) || (actived == null && this.request.search[this.request.search[0]] != null)) this.activedAction = action;
		action.controller = this;
		action.search = this.request.search;
		action.input = this.request.input;
		if (this.fillAction) this.fillAction(action);
		return action;
	}

	this.checkPermission = function(hasPermission) {
		if (!hasPermission) this.outputPage("noPermission");
	}

	this.getPage = function(page) {
		if (this.pageContentType == "html") page.contentType = "html";
		page.xslFile = this.rootPath + "_skins/" + this.pageSkin + "/template/" + this.pageName + ".xsl";
		page.rootPath = this.rootPath;
		page.visitor = {
			id: this.visitor.id,
			loggedIn: this.visitor.loggedIn,
			nickname: this.visitor.nickname,
			group: this.visitor.group
		}
		if (this.msg) page.msg = this.lang(this.msg);

		return page;
	}

	this.outputPage = function(root, content) {
		if (!content) content = this.lang(root);
		var page = this.getPage(new Page(root));
		page.content.setContent(content);
		page.output();
		Response.End();
	}
	
	this.execute = function() {
		if (this.activedAction) this.activedAction.action();
		else this.outputPage("badURL");
		Response.End();
	}

	this.load = function() {
		var path = transformPath(getAbsolutePath(this.request.path, this.pathDepth), this.request.path);
		this.rootPath = transformPath(this.request.path, getAbsolutePath(this.request.path, PATH_DEPTH));
		this.pageName = path.substring(0, path.lastIndexOf("/") + 1) + this.request.path.substring(this.request.path.lastIndexOf("/") + 1, this.request.path.lastIndexOf(".")).toLowerCase();
		lang = getLangs(this.request.path, this.rootPath + ".lang/" + this.name + "/" + this.language + ".xml", this.pageName);
	}
}
</script>
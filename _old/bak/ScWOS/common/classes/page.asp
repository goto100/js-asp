<%
//////////////////////////////////////////////////
// Class Name: Page
// Author: ScYui
// Last Modify: 2005/9/19
//////////////////////////////////////////////////
function Page() {
	////////// Attributes //////////////////////////////
	// Private //////////
	var skin = "default";
	var pathInfo = String(Request.ServerVariables("PATH_INFO"));
	var rootStr = "";

	var dom = new XMLDom();

	// Public //////////
	this.name = "";
	this.fullName = "";
	this.path = "";
	this.referer = getSiteSession("pageReferer");
	this.silent = "";
	this.language = user.usingLang;
	this.contentType = "html";

	this.content = {};

	////////// Methods //////////////////////////////
	// Private //////////

	// Get path
	function getPath() {
		var pathDepth = pathInfo.match(/\//gi).length - 1 - PATHDEPTH;
		var path = pathInfo.substring(0, pathInfo.lastIndexOf("/"));
		var result = "", right = "";
		for (var i = 0; i < pathDepth; i++) {
			right = path.substring(path.lastIndexOf("/"));
			path = path.substring(0, path.lastIndexOf("/"));
			result = right + result;
		}
		return result.slice(1) + "/";
	}

	// Get all Request.QueryString
	function getSearchs() {
		var result = false;
		var search = [];
		var e = new Enumerator(Request.QueryString);
		for (; !e.atEnd(); e.moveNext()) {
			x = String(e.item());
			search[x] = String(Request.QueryString(x));
			while (x.indexOf("&") != -1) {
				var temp = search[x];
				search[x.substring(0, x.indexOf("&"))] = "";
				x = x.substring(x.indexOf("&") + 1, x.length);
				search[x] = temp;
			}
			result = true;
		}
		if (result) return search;
		else return false;
	}

	// Get all Request.Form
	function getInputs() {
		var result = false;
		var input = [];
		e = new Enumerator(Request.Form);
		for (; !e.atEnd(); e.moveNext()) {
			x = e.item();
			input[String(x)] = String(Request.Form(x));
			result = true;
		}
		if (result) return input;
		else return false;
	}

	// Get silent
	function getSilent() {
		var userAgentString = String(Request.ServerVariables("HTTP_USER_AGENT")).toUpperCase();
		if (userAgentString.indexOf("MSIE 6.0") != -1 && userAgentString.indexOf("OPERA") == -1) return "MSIE 6.0";
		else if (userAgentString.indexOf("MOZILLA") != -1) return "MOZILLA";
	}

	// Public //////////
	this.load = function() {
		this.fullName = pathInfo.substring(pathInfo.lastIndexOf("/") + 1);
		this.name = this.fullName.substring(0, this.fullName.lastIndexOf("."));
		this.path = getPath();
		rootStr = transformPath(this.path);
		this.search = getSearchs();
		this.input = getInputs();
		this.silent = getSilent();
	}

	// Get language
	this.getLangs = function() {
		var fileName = this.path.slice(0, -1);
		var itemName = this.name;
		if (fileName.indexOf("/") != -1) {
			fileName = fileName.slice(0, fileName.indexOf("/"));
			itemName = this.path.substr(this.path.indexOf(fileName) + fileName.length + 1) + "/" + itemName;
		}
		var domLang = XMLDom.create();
		domLang.load(this.transformPath("languages/" + this.language + "/" + fileName + ".asp", true));

		if (domLang.documentElement) {
			var lang = [];
			var eleItems = domLang.documentElement.getElementsByTagName("items");
			for (var i = 0; i < eleItems.length; i++) {
				var type = eleItems[i].getAttribute("page");
				if (type == itemName) {
					var eleLangs = eleItems[i].getElementsByTagName("item");
					for (var j = 0; j < eleLangs.length; j++) {
						lang[eleLangs[j].getAttribute("id")] = eleLangs[j].text;
					}
					i = eleItems.length;
				}
			}

			return lang;
		} else outputErrorMsg("Load language file ERROR.");
	}

	// Get referer
	this.getReferer = function() {
		if (String(Request.ServerVariables("HTTP_REFERER")) != "undefined") {
			this.referer = String(Request.ServerVariables("HTTP_REFERER"));
			setSiteSession("pageReferer", this.referer);
		}
	}

	// Transform path
	this.transformPath = function(path, isAbsolute) {
		if (path.substr(0, 1) == "/") {
			path = path.substr(1);
			for (var i = 0; i < PATHDEPTH; i++) {
				path = "../" + path;
			}
		}
		if (isAbsolute == true) return Server.MapPath(rootStr + path);
		return rootStr + path;
	}

	// Set root element
	this.setRoot = function(name, type) {
		this.content = dom.setRoot(name);
		if (type) this.content.addAttribute("type",type);
	}

	// Output page
	this.output = function() {
		var result = "";
		if (!this.search.c && this.referer) this.content.addAttribute("referer", this.referer);
		if (this.search.c) this.content.addAttribute("rootStr", transformPath(this.search.b));

		if (this.search.o != "html" && (this.silent == "MSIE 6.0" || this.silent == "MOZILLA")) { // XML
			this.contentType = "xml";

			result = "<?xml version=\"1.0\" encoding=\"utf-8\"?>";
			if (this.search.c) result += "\r\n<?xml-stylesheet type=\"text/xsl\" href=\"" + transformPath(search.b, "skins/" + skin + "/template/" + search.s + ".xsl") + "\"?>";
			else result += "\r\n<?xml-stylesheet type=\"text/xsl\" href=\"" + this.transformPath("skins/" + skin + "/template/" + this.path + this.name + ".xsl") + "\"?>";
			result += "\r\n" + dom.documentElement.xml;
		} else { // HTML
			var domTemplate = XMLDom.create();

			try {
				domTemplate.load(this.transformPath("skins/" + skin + "/template/" + this.path + this.name + ".xsl", true));
				if (domTemplate.parseError.errorCode != 0) throw "Read template file ERROR";
			} catch(e) {
				outputErrorMsg(e);
			}

			result = dom.transformNode(domTemplate);
		}

		if (this.contentType == "xml") Response.ContentType = "text/xml";

		write(result);
	}

	// Output a system message
	this.outputMsg = function(type, content, getReferer) {
		this.setRoot(type);
		if (!getReferer) this.getReferer();
		this.content.addAttribute("type", "msg");
		if (content) this.content.setContent(content);
		this.output();
	}

	// Get XML Form
	this.getForm = function(dbForm, action, node) {
		if (!node) node = this.content;
		if (!action) {
			if (dbForm.mode == "add") action = "add=do";
			else if (dbForm.mode == "edit") action = "edit=do";
		}
		node.addAttribute("method", "post");
		node.addAttribute("action", dbForm.action);
		node.addAttribute("secCode", dbForm.secCode);

		for (var i = 0; i < dbForm.items.length; i++) {
			var tEle = node.addChild(dbForm.items[i].name, {
					"title":dbForm.items[i].title
				, "type":dbForm.items[i].type
				, "emptyOk":dbForm.items[i].emptyOk
				, "minLength":dbForm.items[i].minLength
				, "maxLength":dbForm.items[i].maxLength
				, "error":dbForm.items[i].error
			}, dbForm.items[i].value);
			if (dbForm.items[i].values) {
				var eleValues = tEle.addChild("values");
				for (var j = 0; j < dbForm.items[i].values.length; j++)
				eleValues.addChild("value", {"title":dbForm.items[i].values[j].title}, dbForm.items[i].values[j].value);
			}
		}
	}

	// Output table
	this.getTable = function(size) {
		this.size = size;
		this.current = getCurrentPage();

		function getCurrentPage() {
			var p = parseInt(this.search.p);
			if (!p || p < 1) return 1;
			else return p;
		}

		function getPageCount(count, size) {
			var result = count/size;
			if (parseInt(result) < result) return parseInt(result) + 1;
			else return result;
		}

		function getPageParam() {
			return String(Request.QueryString).replace(/&*p=\d+&*/ig, "");
		}

		this.addNodeToPage = function(element, count) {
			var pageParam = getPageParam();
			if (pageParam) element.addAttribute("pageParam", pageParam);
			element.addAttribute("pageSize", this.size);
			element.addAttribute("pageCount", getPageCount(count, this.size));
			element.addAttribute("currentPage", this.current);
			element.addAttribute("recordCount", count);
		}

		return this;
	}

	// Redirect
	this.redirect = function(url) {
		Response.Redirect(url);
	}
}
%>

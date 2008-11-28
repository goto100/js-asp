<!-- #include file = "../../../common/classes/dbform.asp" -->
<!-- #include file = "../../../common/classes/fso.asp" -->
<%
//////////////////////////////////////////////////
// Class Name: Article
// Author: ScYui
// Last Modify: 2005/11/14
//////////////////////////////////////////////////
function Article() {
	////////// Attributes //////////////////////////////
	// Private //////////

	// Public //////////
	this.id = 0;
	this.title = "";
	this.cate = {"id":0, "name":""};
	this.author = "";
	this.from = "";
	this.content = "";
	this.publisher = {"id":0, "name":""};
	this.time = "";
	this.builtPath = "";
	this.builtName = "";
	this.builtType = "";

	////////// Methods //////////////////////////////
	// Private //////////

	// Get side article
	function getSideArticle(time, isNext) {
		var tag = isNext? ">" : "<";
		var sql = "SELECT TOP 1 id, title FROM [Articles] WHERE time ";
		sql += isNext? ">" : "<";
		sql += " #" + new Date(time).format() + "# ORDER BY time ";
		sql += isNext? "ASC" : "DESC";
		var tmpA = Article.conn.query(sql);
		if (tmpA != null) return tmpA;
	}

	// Public //////////

	// Fill
	this.fill = function(value) {
		this.id = value["id"];
		this.title = value["title"];
		this.category = {"id":value["cateId"], "name":value["name"]};
		this.author = value["author"];
		this.from = value["from"];
		this.content = value["content"];
		this.publisher = {"id":value["publisherId"], "name":value["publisher"]};
		this.time = value["time"];
		this.builtPath = value["builtPath"];
		this.builtName = value["builtName"];
		this.builtType = value["builtType"];
	}

	// Side article
	this.getSideArticle = function() {
		var tmpA = getSideArticle(this.time);
		var tmpA2 = getSideArticle(this.time, true);
		if (tmpA)	this.previousArticle = {id:tmpA["id"], title:tmpA["title"]};
		if (tmpA2) this.nextArticle = {id:tmpA2["id"], title:tmpA2["title"]};
	}

	// Update a article
	this.edit = function(input) {
		this.form = Article.fillForm(true, true);
		var oldPath = "";
		var tmpA = artiConn.query("SELECT TOP 1 builtPath, builtName, builtType FROM [Articles] WHERE id = " + input.id);
		oldPath = tmpA["builtPath"] + tmpA["builtName"] + Article.getBuiltType(parseInt(tmpA["builtType"]));
		var path = input.builtPath + input.builtName + Article.getBuiltType(parseInt(input.builtType));
		if (oldPath != path) {
			var fso = new FSO();
			if (fso.fileExists(page.transformPath(path, true))) {
				this.form.addItem(false, "rebuiltFile", "bool");
				if (input.rebuiltFile) return true;
				else {
					this.form.item.builtName.error = lang["builtName_have_file"];
				}
			}
		}
		if (this.form.submit(input)) {
			if (path) {
				if (!oldPath || (path == oldPath)) {
					this.built();
				} else if (path != oldPath) {
					this.built();
					Article.del(oldPath);
				}
			} else if (!path && oldPath) {
				Article.del(oldPath);
			}
			return true;
		} else return false;
	}

	// Create a article file
	this.built = function() {
		Article.built(parseInt(input.id), input.builtPath + input.builtName + Article.getBuiltType(parseInt(input.builtType)));
	}

}
////////// Static //////////////////////////////

// Fill form
Article.fillForm = function(isEdit, isSubmit) {
	var form = new DBForm();
	form.mode = isEdit? "edit" : "add";

	var title = form.addItem(true, "title", "string", true, lang["title_must"]);
	title.setMaxLength(255, lang["title_long"]);
	var cateId = form.addItem(true, "cateId", "number", true, lang["cateId_must"]);
	var tmpA = Article.conn.query("SELECT id AS [value], name AS title"
		+ " FROM [Categories]"
		+ " ORDER BY [rootOrder], [order]");
	cateId.setValues(tmpA, lang["cateId_wrong"]);
	form.addItem(true, "author", "string");
	form.addItem(true, "from", "string");
	form.addItem(true, "content", "string");
	if (isEdit) {
		form.addItem("sign", "id", "number", true);
		form.addItem(false, "updatePublisher", "bool");
		form.addItem(false, "updateTime", "bool");
		var builtPath = form.addItem(true, "builtPath", "string");
		var builtName = form.addItem(true, "builtName", "string");
		var builtType = form.addItem(true, "builtType", "number");
	} else {
		form.addItem(false, "redefBPath", "bool");
		form.addItem(false, "redefBName", "bool");
		form.addItem(false, "redefBType", "bool");
		var builtPath = form.addItem(input.redefBPath, "builtPath", "string");
		if (input.redefBName) var builtName = form.addItem(input.redefBName, "builtName", "string", true, lang["builtName_must"]);
		else var builtName = form.addItem(input.redefBName, "builtName", "string");
		var builtType = form.addItem(input.redefBType, "builtType", "number");
	}
	builtType.setValues([{"value":1, "title":"XML"}], lang["builtType_wrong"]);

	if (isSubmit) {
		form.conn = artiConn;
		form.table = "Articles";
		if (!isEdit || (isEdit && input.updateTime)) form.addSubmit("time", new Date());
		if (!isEdit || (isEdit && input.updatePublisher)) {
			form.addSubmit("publisherId", user.id);
			form.addSubmit("publisher", user.nickname);
		}
		if (!isEdit) {
			if (input.cateId && (!input.redefBPath || !input.redefBName || !input.redefBType)) {
				var tmpA = Article.conn.query("SELECT TOP 1 builtPath, builtName, builtType"
					+ " FROM [Categories]"
					+ " WHERE id = " + input.cateId);
			}

			var path = Article.getBuiltPath(input.redefBPath? input.builtPath : tmpA["builtPath"]);
			var name = Article.getBuiltName(input.redefBName? input.builtName : tmpA["builtName"]);
			var type = parseInt(input.redefBType? input.builtType : tmpA["builtType"]);

			form.addSubmit("builtPath", path);
			form.addSubmit("builtName", name);
			form.addSubmit("builtType", type);

			path = path + name + Article.getBuiltType(type);

			var fso = new FSO();

			if (input.redefBPath) {
				if (!fso.folderExists(page.transformPath(input.builtPath, true))) {
					form.addItem(false, "createPath", "bool");
					if (!input.createPath) builtPath.error = lang["builtPath_no_folder"];
				}
			}
			if (input.redefBName) {
				if (fso.fileExists(page.transformPath(path, true))) {
					form.addItem(false, "rebuiltFile", "bool");
					if (!input.rebuiltFile) builtName.error = lang["builtName_have_file"];
				}
			}
		}
	}
	return form;
}

// Add an article
Article.add = function(input) {
	var form = Article.fillForm(false, true);
	if (form.submit(input)) {
		var tmpA = Article.conn.query("SELECT TOP 1 id, builtPath, builtName, builtType FROM [Articles] ORDER BY id DESC");
		if (tmpA["builtName"] && tmpA["builtType"]) {
			var fso = new FSO();
			if (input.createPath) fso.createPath(page.transformPath(tmpA["builtPath"], true));
			var path = tmpA["builtPath"] + tmpA["builtName"] + Article.getBuiltType(parseInt(tmpA["builtType"]));
			Article.built(parseInt(tmpA["id"]), path);
		}
		return true;
	}
	else {
		Article.form = form;
		return false;
	}
}

// Delete a article file
Article.del = function(path) {
	var fso = new FSO();
	fso.deleteFile(page.transformPath(path, true));
}

// Create article file
Article.built = function(id, path) {
	var fso = new FSO();
	var file = "article.asp?id=" + id + "&c=xml&b=" + path + ".xml&s=article/article";

	var url = String(Request.ServerVariables("URL"));
	var xmlHttp = new ActiveXObject("Microsoft.XMLHttp");
	xmlHttp.open("GET", "http://" + Request.ServerVariables("SERVER_NAME") + url.substr(0, url.lastIndexOf("/") + 1) + file, false);
	xmlHttp.send(null);
	var result = xmlHttp.responseText;
	fso.builtFile(page.transformPath(path, true), result);
}

// Get file path
Article.getBuiltPath = function(str) {
	if (str.slice(-1) != "/") str += "/";
	while (true) {
		var arr;
		if (arr = /\$random\((\d+)\)\$/gi.exec(str)) str = str.replace(arr[0], random(arr[1]));
		else return str;
	}
}

// Get file name
Article.getBuiltName = function(str) {
	while (true) {
		var arr;
		if (arr = /\$random\((\d+)\)\$/gi.exec(str)) str = str.replace(arr[0], random(arr[1]));
		else return str;
	}
}

// Get file type
Article.getBuiltType = function(id) {
	switch (id) {
		case 1: return ".xml";
		default: return ".xml";
	}
}
%>

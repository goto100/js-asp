<script language="javascript" runat="server">
function Action()
{
	this.visitor = null;

	this.getPage = function(page)
	{
		if (this.pageContentType == View.HTML) view.contentType = View.HTML;
		view.setXslFile(this.rootPath + "skins/" + this.pageSkin + "/template/" + this.pageName + ".xsl");
		view.rootPath = this.rootPath;
		view.visitor =
		{
			id: this.visitor.id,
			loggedIn: this.visitor.loggedIn,
			nickname: this.visitor.nickname,
			group: this.visitor.group
		}
		if (this.msg) view.msg = this.lang(this.msg);

		return page;
	}

	// Get language
	function getLangs(requestPath, filePath, pageName) {
		var i, j, eleLangs, attPage, file = Server.MapPath(filePath), fileName = requestPath.slice(0, -1), domLang = new XMLDom;

		if (fileName.indexOf("/") != -1) fileName = fileName.slice(0, fileName.indexOf("/"));
		domLang.load(file);
		if (!domLang.documentElement) return {};

		var lang = {};
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

	this.controller = null;
	this.action = null;
	this.param = {};

	this.lang = function(key)
	{
		return lang[key] || key;
	}

	this.getNumber = function(str, min, max, matchs)
	{
		var number = Number(str);

		if (isNaN(number)) throw new Error(1);
		if (min && number < min) throw new NumberTooSmallException();
		if (max && number > max) throw new NumberTooBigException();
		if (matchs) {
			for (var i = 0; i < matchs.length; i++) if (number == Number(matchs[i])) break;
			if (i >= matchs.length) throw new NotMatchException();
		}
		return number;
	}

	this.getNumbers = function(str, spliter, min, max, matchs)
	{
		var numbers = str.split(spliter);

		for (var i = 0; i < numbers.length; i++)
		{
			try {
				numbers[i] = this.getNumber(numbers[i], min, max, matchs);
			} catch (e) {
				numbers.splice(i--, 1);
			}
		}
		return numbers.length? numbers : null;
	}

	this.getString = function(str, minLength, maxLength, matchs) {
		if (minLength && str.length < minLength) throw new StringTooShortException();
		if (maxLength && str.length > maxLength) throw new StringTooLongException();
		if (matchs) {
			if (matchs.constructor == RegExp) {
				 if (!str.match(matchs)) throw new NotMatchException();
			} else if (matchs.constructor == Array) {
				for (var i = 0; i < matchs.length; i++) if (str == matchs[i]) break;
				if (i >= matchs.length) throw new NotMatchException();
			} else if (str != matchs) throw new NotMatchException();
		}
		return str;
	}

	this.getStrings = function(str, spliter, minLength, maxLength, matchs) {
		var strings = str.split(spliter);

		for (var i = 0; i < strings.length; i++) {
			try {
				strings[i] = this.getString(strings[i], minLength, maxLength, matchs);
			} catch (e) {
				strings.splice(i--, 1);
			}
		}
		return strings;
	}

	this.getBooleans = function(str, spliter) {
		var booleans = str.split(spliter);
		for (var i = 0; i < booleans.length; i++) booleans[i] = Boolean(booleans[i]);
		return booleans;
	}

	this.getDate = function(str, min, max, matchs) {
		var date = new Date(str.replace(/-/ig, "/"));

		if (isNaN(date)) throw new Error(1);
		if (min && date < min) throw new Error(2);
		if (max && date > max) throw new Error(3);
		if (matchs) {
			for (var i = 0; i < matchs.length; i++) if (date == matchs[i]) break;
			if (i >= matchs.length) throw new NotMatchException(4);
		}
		return date;
	}

	this.lang = function(key) {
		return this.controller.lang(key);
	}

	this.getIdParam = function(type) {
		if (this.param.id) return this.param.id;
		if (!this.search.id && !this.input.id) this.controller.outputPage("badURL");
		try {
			switch (type) {
				case "string": return this.search.id || this.input.id;
				case "number":
				default:
					return this.getNumber(this.search.id || this.input.id, 1);
			}
		} catch (e) {
			return 0;
		}
	}

	this.execute = function(msg) {
		lang = getLangs(this.request.path, this.rootPath + ".lang/" + this.language + ".xml", this.pageName);
		if (msg) this.controller.msg = msg;
		this.action();
	}

	var lang;
}
Action.NO_ACTION = 0;
Action.BAD_URL = 1;
Action.NO_PERMISSION = 2;
</script>
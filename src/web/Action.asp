<script language="javascript" runat="server">
function Action() {
	this.method = "GET";
	this.request;
	this.search;
	this.input;
	this.param;
	this.action = function() {
		writeln("This action is undefined.");
	};
	this._controller;
}

Action.prototype.setController = function(controller) {
	this._controller = controller;
	this.request = controller.request;
	this.search = this.request.search;
	this.input = this.request.input;
}

Action.prototype.redirect = function(url) { 
	Response.Redirect(url);
}

Action.prototype.execute = function() {
	this._controller.context = this;
	this.action();
}

Action.prototype.getNumber = function(str, min, max, matchs) {
	var number = Number(str);
	if (isNaN(number)) throw new Error(1);
	if (min && number < min) throw new Error(2);
	if (max && number > max) throw new Error(3);
	if (matchs) {
		for (var i = 0; i < matchs.length; i++) if (number == Number(matchs[i])) break;
		if (i >= matchs.length) throw new Error(4);
	}
	return number;
}

Action.prototype.getNumbers = function(str, spliter, min, max, matchs) {
	var i, numbers = str.split(spliter);
	for (i = 0; i < numbers.length; i++) {
		try {
			numbers[i] = this.getNumber(numbers[i], min, max, matchs);
		} catch (e) {
			numbers.splice(i--, 1);
		}
	}
	return numbers.length? numbers : null;
}

Action.prototype.getString = function(str, minLength, maxLength, matchs) {
	var i;

	if (minLength && str.length < minLength) throw new Error(2);
	if (maxLength && str.length > maxLength) throw new Error(3);
	if (matchs) {
		if (matchs.constructor == RegExp) {
			 if (!str.match(matchs)) throw new Error(4);
		} else if (matchs.constructor == Array) {
			for (i = 0; i < matchs.length; i++) if (str == matchs[i]) break;
			if (i >= matchs.length) throw new Error(4);
		} else if (str != matchs) throw new Error(4);
	}
	return str;
}

Action.prototype.getStrings = function(str, spliter, minLength, maxLength, matchs) {
	var i, strings = str.split(spliter);
	for (i = 0; i < strings.length; i++) {
		try {
			strings[i] = this.getString(strings[i], minLength, maxLength, matchs);
		} catch (e) {
			strings.splice(i--, 1);
		}
	}
	return strings;
}

Action.prototype.getBooleans = function(str, spliter) {
	var i, booleans = str.split(spliter);
	for (i = 0; i < booleans.length; i++) booleans[i] = Boolean(booleans[i]);
	return booleans;
}

Action.prototype.getDate = function(str, min, max, matchs) {
	var i, date = new Date(str.replace(/-/ig, "/"));
	if (isNaN(date)) throw new Error(1);
	if (min && date < min) throw new Error(2);
	if (max && date > max) throw new Error(3);
	if (matchs) {
		for (i = 0; i < matchs.length; i++) if (date == matchs[i]) break;
		if (i >= matchs.length) throw new Error(4);
	}
	return date;
}

Action.prototype.getId = function() {
	if (!this.search.path) return;
	var numbers = this.search.path.filter(function(part) {
		part = parseInt(part);
		if (part) return true;
	});
	return numbers[numbers.length - 1];
}

</script>
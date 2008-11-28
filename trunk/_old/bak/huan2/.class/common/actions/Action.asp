<script language="javascript" runat="server">
function Action() {
	this.controller = null;
	this.action = null;
	this.param = {}

	this.getNumber = function(str, min, max, matchs) {
		var i, number = Number(str);
		if (isNaN(number)) throw new Error(1);
		if (min && number < min) throw new Error(2);
		if (max && number > max) throw new Error(3);
		if (matchs) {
			for (i = 0; i < matchs.length; i++) if (number == Number(matchs[i])) break;
			if (i >= matchs.length) throw new Error(4);
		}
		return number;
	}

	this.getNumbers = function(str, spliter, min, max, matchs) {
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

	this.getString = function(str, minLength, maxLength, matchs) {
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

	this.getStrings = function(str, spliter, minLength, maxLength, matchs) {
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

	this.getBooleans = function(str, spliter) {
		var i, booleans = str.split(spliter);
		for (i = 0; i < booleans.length; i++) booleans[i] = Boolean(booleans[i]);
		return booleans;
	}

	this.getDate = function(str, min, max, matchs) {
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
		if (msg) this.controller.msg = msg;
		this.action();
	}
}
</script>
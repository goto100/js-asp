<%
//////////////////////////////////////////////////
// Class Name: Form
// Author: ScYui
// Last Modify: 2005/10/31
//////////////////////////////////////////////////

function DBForm() {
	this.mode = ""; // add, edit, check
	this.table = "";
	this.secCode = "";
	this.items = [];
	this.submits = [];

	// Add item
	this.addItem = function(submit, name, type, must, emptyError) {
		var item = {
				"submit":submit
			, "name":name
			, "title":lang[name + "_title"]
			, "type":type
			, "emptyOk":must? false:true
			, "emptyError":emptyError
			, "setMinLength":function(length, error) {
				this.minLength = length;
				this.tooShortError = error;
			}
			, "setMaxLength":function(length, error) {
				this.maxLength = length;
				this.tooLongError = error;
			}
			, "setMatch":function(match, error) {
				this.match = match;
				this.notMatchError = error;
			}
			, "setValues":function(values, error) {
				this.values = values;
				this.wrongValueError = error;
			}
		};
		this.items.push(item);
		return item;
	}

	// Add submit
	this.addSubmit = function(name, value) {
		this.submits.push({"name":name, "value":value});
	}

	// Check form
	this.check = function(input) {
		var haveError = false;

		for (var i = 0; i < this.items.length; i++) {
			var item = this.items[i];
			item.value = input[item.name];

			if (item.emptyOk == false && !item.value) { // Empty
				item.error = item.emptyError;
				haveError = true;
			} else if (item.value && item.minLength != null && item.value.length < item.minLength) { // Too short
				item.error = item.tooShortError;
				haveError = true;
			} else if (item.value && item.maxLength != null && item.value.length > item.maxLength) { // Too long
				item.error = item.tooLongError;
				haveError = true;
			} else if (item.value && item.values != null) {
				var tmp = false;
				for (var j = 0; j < item.values.length; j++) {
					if (item.value == item.values[j].value) {
						tmp = true;
						j = item.values.length;
					}
				}
				if (!tmp) {
					item.error = item.wrongValueError;
					haveError = true;
				}
			} else if (item.value && item.match && !item.value.match(item.match)) {
				item.error = item.notMatchError;
				haveError = true;
			}
		}

		if (haveError) return false;
		else return true;
	}

	// Do
	this.submit = function(input) {
		if (this.check(input)) {
			if (this.mode == "add" || this.mode == "edit") {
				var sql = {};
				for (var i = 0; i < this.items.length; i++) {
					if (this.items[i].submit == "sign") {
						var where = "";
						switch (this.items[i].type) {
							case "string":
								where = "[" + this.items[i].name + "] = '" + input[this.items[i].name] + "'";
								break;
							case "number":
								where = "[" + this.items[i].name + "] = " + input[this.items[i].name];
								break;
						}
					} else if (this.items[i].submit) {
						switch (this.items[i].type) {
							case "string":
								sql[this.items[i].name] = input[this.items[i].name];
								break;
							case "number":
								sql[this.items[i].name] = parseInt(input[this.items[i].name]);
								break;
						}
					}
				}
				for (var i = 0; i < this.submits.length; i++) {
					sql[this.submits[i].name] = this.submits[i].value;
				}
				if (this.mode == "add") this.conn.insert(this.table, sql);
				if (this.mode == "edit") this.conn.update(this.table, sql, where);
			
			}
			return true;
		} else return false;
	}
}
%>

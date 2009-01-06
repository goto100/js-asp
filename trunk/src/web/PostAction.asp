<script language="javascript" runat="server">
function PostAction() {
	this.method = "POST";
	this.param = {};
	this.form;
	this.hasError = false;
}
PostAction.prototype = new Action();

PostAction.prototype.execute = function() {
	if (this.validate) this.validate();
	if (this.hasError) this.from.execute();
	this.action();
}

PostAction.prototype.withStringParam = function(name, required, minLength, maxLength, matchs) {
	var form = {error: null, value: null, input: this.input.get(name)};
	if (!form.input) {
		if (required == true) form.error = new Error(0, name + " required");
		else this.param[name] = required || null;
	} else {
		try {
			this.param[name] = this.getString(form.input, minLength, maxLength, matchs);
		} catch (e) {
			switch (e.number) {
				case 2: e.description = name + " short"; break;
				case 3: e.description = name + " long"; break;
				case 4: e.description = name + " not match"; break;
				default: e.description = name + " unknown error";
			}
			form.error = e;
		}
	}
	if (form.error) this.hasError = true;
}

PostAction.prototype.withStringsParam = function(name, value, spliter, minLength, maxLength, matchs) {
	if (!spliter) spliter = /,\s*/ig;
	var form = this.form[name] = new DBActionFormItem(this.input[name]);
	if (!form.value()) {
		if (value == true) form.error = new Error(0, name + "Required");
		else this.param[name] = value || null;
	} else this.param[name] = this.getStrings(form.value(), spliter, minLength, maxLength, matchs);
	if (form.error) this.hasError = true;
}

PostAction.prototype.withNumberParam = function(name, value, min, max, matchs) {
	var form = this.form[name] = new DBActionFormItem(this.input[name]);
	if (!form.value()) {
		if (value == true) form.error = new Error(0, name + "Required");
		else if (value) this.param[name] = value;
		else this.param[name] = null;
	} else {
		try {
			this.param[name] = this.getNumber(form.value(), min, max, matchs);
		} catch (e) {
			switch (e.number) {
				case 1: e.description = name + "Wrong"; break;
				case 2: e.description = name + "Small"; break;
				case 3: e.description = name + "Big"; break;
				case 4: e.description = name + "NotMatch"; break;
				default: e.description = "unknownError";
			}
			form.error = e;
		}
	}
	if (form.error) this.hasError = true;
}

PostAction.prototype.withEmailParam = function(name, value) {
	var form = this.form[name] = new DBActionFormItem(this.input[name]);
	if (!form.value()) {
		if (value == true) form.error = new Error(0, name + "Required");
		else if (value) this.param[name] = value;
		else this.param[name] = null;
	} else {
		try {
			this.param[name] = this.getString(form.value(), null, null, (/^[\w]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$/ig));
		} catch (e) {
			switch (e.number) {
				case 4: e.description = name + "Wrong"; break;
				default: e.description = "unknownError";
			}
			form.error = e;
		}
	}
	if (form.error) this.hasError = true;
}

PostAction.prototype.withDateParam = function(name, value, min, max, matchs) {
	var form = this.form[name] = new DBActionFormItem(this.input[name]);
	if (!form.value()) {
		if (value == true) form.error = new Error(0, name + "Required");
		else if (value) this.param[name] = value;
		else this.param[name] = null;
	} else {
		try {
			this.param[name] = this.getDate(form.value(), min, max, matchs);
		} catch (e) {
			switch (e.number) {
				case 1: e.description = name + "Wrong"; break;
				case 2: e.description = name + "Small"; break;
				case 3: e.description = name + "Big"; break;
				case 4: e.description = name + "NotMatch"; break;
				default: e.description = "unknownError";
			}
			form.error = e;
		}
	}
	if (form.error) this.hasError = true;
}

PostAction.prototype.withBooleanParam = function(name) {
	var form = this.form[name] = new DBActionFormItem(this.input[name]);
	if (!form.value()) this.param[name] = false;
	else this.param[name] = true;
}

PostAction.prototype.withFileParam = function() {
	
}

PostAction.prototype.withFilesParam = function() {
	
}

PostAction.prototype.setParamError = function(name, error) {
	this.form[name].error = error;
	this.hasError = true;
}

</script>
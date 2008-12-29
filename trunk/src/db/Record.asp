<script language="javascript" runat="server">
function Record(rs) {
	this._rs = rs;
}

Record.prototype.get = function(name) {
	try {
		var value = this._rs.Fields(name).Value;
	} catch(e) {
		// Do nothing
	}
	if (typeof value == "date") {
		value = new Date(value);
		value.setMinutes(value.getMinutes() - value.getTimezoneOffset());
	}
	return value;
}

Record.prototype.getKeys = function() {
	var keys = [];
	var e = new Enumerator(this._rs.Fields);
	for (; !e.atEnd(); e.moveNext()) keys.push(e.item().Name);

	return keys;
}

</script>
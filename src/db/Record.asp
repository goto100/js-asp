<script language="javascript" runat="server">
function Record(rs) {
	this._rs = rs;
}

Record.prototype.get = function(name) {
	var value = this._rs.Fields(name).Value;
	if (typeof value == "date") {
		value = new Date(value);
		value.setMinutes(value.getMinutes() - value.getTimezoneOffset());
	}
	return value;
}

Record.prototype.getFieldNames = function() {
	var names = [];
	var e = new Enumerator(this._rs.Fields);
	for (; !e.atEnd(); e.moveNext()) names.push(e.item().Name);

	return names;
}

</script>
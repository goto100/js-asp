<script language="javascript" runat="server">
function Record(rs) {
	this.getFieldNames = function() {
		var names = [];
		var e = new Enumerator(rs.Fields);
		for (; !e.atEnd(); e.moveNext()) names.push(e.item().Name);

		return names;
	}

	// Get current record from recordset
	this.getRecord = function(names) {
		var result = {}
		for (var i = 0; i < names.length; i++) {
			var value = rs.Fields(names[i]).Value;
			result[names[i]] = (typeof value == "date")? Date.fromGMT(value) : value;
		}

		return result;
	}

	this.item = function() {
		return this.getRecord(this.getFieldNames());
	}
}
</script>
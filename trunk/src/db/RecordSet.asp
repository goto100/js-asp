<script language="javascript" runat="server">
function RecordSet(rs) {
	this._rs = rs;
	this._index = 0;

	this.recordCount = rs.RecordCount;
	this.pageSize = rs.PageSize;
	this.currentPage = rs.AbsolutePage;
	this.pageCount = rs.PageCount;
}

RecordSet.prototype.forEach = function(callback) {
	if (callback) for (; !this.atEnd(); this.moveNext()) callback(new Record(this._rs));
}

RecordSet.prototype.atEnd = function() {
	if (this._rs.EOF || (this.pageCount > 0 && this._index >= this.pageSize)) {
		this._rs.Close();
		delete this._rs;
		return true;
	} else return false;
}

RecordSet.prototype.moveNext = function() {
	this._rs.MoveNext();
	this._index++;
}

RecordSet.prototype.toPojos = function(mapping) {
	var pojos = [];
	this.forEach(function(record) {
		var names = record.getKeys();
		var result = {};
		for (var i = 0; i < names.length; i++) result[names[i]] = record.get(names[i]);
		pojos.push(result);
	});
	return pojos;
}
</script>
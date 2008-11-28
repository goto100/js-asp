<script language="javascript" runat="server">
function RecordCollection(rs) {
	Record.call(this, rs);

	var index = 0;

	this.recordCount = rs.RecordCount;
	this.pageSize = rs.PageSize;
	this.currentPage = rs.AbsolutePage;
	this.pageCount = rs.PageCount;

	this.atEnd = function() {
		if (rs.EOF || (this.pageCount > 0 && index >= this.pageSize)) {
			rs.Close();
			delete rs;
			return true;
		} else return false;
	}

	this.moveNext = function() {
		rs.MoveNext();
		index++;
	}

	this.toArray = function() {
		var array = [];
		for (; !this.atEnd(); this.moveNext()) array.push(this.item());
		return array;
	}

	this.toList = function() {
		var list = new List(this);
		for (; !this.atEnd(); this.moveNext()) list.push(this.item());
		return list;
	}
}
</script>
<script language="javascript" runat="server">
function List() {
	this.length = 0;
	this.orders = null;
	this.pageSize = null;
	this.currentPage = null;
	this.recordCount = null;
	this.pageCount = null;

	this.setPage = function(pageSize, currentPage) {
		this.pageSize = pageSize;
		this.currentPage = currentPage || 1;
	}

	this.getOrderSQL = function(order) {
		if (!this.orders) return "";

		var sql = "";
		for (var i = 0; i < this.orders.length; i++) if (order[this.orders[i].order]) sql += order[this.orders[i].order] + (this.orders[i].isDesc? " DESC, " : " ASC, ");

		return sql? " ORDER BY " + sql.slice(0, -2) : "";
	}

	this.setRecords = function(records) {
		this.recordCount = records.recordCount;
		this.pageCount = records.pageCount;
	}

	this.push = function(value) {
		this[this.length++] = value;
	}

	this.clear = function() {
		for (; this.length; this.length--) delete this[this.length];
	}
}
</script>
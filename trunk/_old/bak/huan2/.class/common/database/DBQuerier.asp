<script language="javascript" runat="server">
function DBQuerier(sql) {
	var db;
	var selectStr = "";
	var fromStr = "";
	var whereStr = "";
	var orderStr = "";

	this.sql = sql;

	this.setDatabase = function(database) {
		db = database;
	}

	this.addTable = function(name, selects, asNames) {
		var table = new String(name);

		fromStr += fromStr? ", " + name + "" : " FROM " + name + "";
		selectStr += selectStr? ", " : "SELECT ";
		if (selects == true) selectStr += name + ".*";
		else {
			for (var i = 0; i < selects.length; i++) {
				table[selects[i]] = name + "." + selects[i];
				selectStr += name + "." + selects[i];
				if (asNames && asNames[i]) selectStr += " AS " + asNames[i];
				selectStr += ", ";
			}
			selectStr = selectStr.slice(0, -2);
		}

		return table;
	}

	this.addWhere = function(where) {
		whereStr += (whereStr? " AND " : " WHERE ") + where;
	}

	this.addOrder = function(order, isDesc) {
		orderStr += (orderStr? ", " : " ORDER BY ") + order + (isDesc? " DESC" : " ASC");
	}

	this.getSql = function() {
		return selectStr + fromStr + whereStr + orderStr;
	}

	this.query = function(length, currentPage, outVbArr) {
		if (!this.sql) this.sql = this.getSql();

		if (length && currentPage) {
			var rs = db.createRecordSet();
			try {
				rs.Open(this.sql, db.getConn(), 1, 1);
			} catch(e) {
				write(e.description)
			}
		} else var rs = db.execute(this.sql);

		if (length && currentPage) {
			rs.PageSize = length;
			if (!rs.BOF && !rs.EOF) rs.AbsolutePage = currentPage;
		}

		if (!outVbArr) {
			if (length == 1) {
				if (rs.BOF && rs.EOF) return;
				return new Record(rs).item();
			} else {
				var records = new RecordCollection(rs);
				return records.atEnd()? null : records;
			}
		} else {
			this.recordCount = rs.recordCount;
			return (rs.BOF && rs.EOF)? null : rs.GetRows();
		}
	}
}
</script>
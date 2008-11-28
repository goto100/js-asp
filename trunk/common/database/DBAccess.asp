<!--#include file="Record.asp" -->
<!--#include file="RecordCollection.asp" -->
<script language="javascript" runat="server">
function DBAccess(dbPath) {
	var conn;

	this.dbPath = dbPath;
	this.opened = false;
	this.hasError = false;

	// Insert different type
	function getSQLStr(value) {
		if (value == null) return "NULL";
		switch (value.constructor) {
			case Boolean: return value? "TRUE" : "FALSE";
			case Number: return value.toString();
			case String: return "'" + value.replace(/\'/ig, "''") + "'";
			case Date: return "#" + value.format("yyyy/MM/dd HH:mm:ss", 0) + "#";
		}
	}

	this.createRecordSet = function() {
		try {
			return new ActiveXObject("ADODB.RecordSet");
		} catch(e) {
			throw new Error(0, "Can't create DB Recordset, you need ADODB.Recordset object.");
		}
	}

	// Open
	this.open = function() {
		try {
			conn = new ActiveXObject("ADODB.Connection");
		} catch(e) {
			throw new Error(0, "Can't create DB Connection, you need ADODB.Connection object.");
		}
		try {
			conn.ConnectionString = "Provider = Microsoft.Jet.OLEDB.4.0; Data Source=" + this.dbPath;
			conn.Open();
		} catch(e) {
			throw new Error(0, "Database Connection failure.");
		}
		this.opened = true;
	}

	// Close
	this.close = function() {
		if (!this.opened) return;
		try {
			conn.Close();
		} catch(e) {
			throw new Error(0, "Close database connection error.");
		}
		delete conn;
		this.opened = false;
	}

	// Execute
	this.execute = function(sql) {
		if (!this.opened) this.open();

		try {
			return conn.Execute(sql, 0, 0x0001);
		} catch(e) {
			write(sql)
			write(e.description)
		}
	}

	// Query by SQL
	this.query = function(sql, length, currentPage, outVbArr) {
		if (!this.opened) this.open();
		DBAccess.executeCount += 1;

		if (length && currentPage) {
			var rs = this.createRecordSet();
			try {
				rs.Open(sql, conn, 1, 1);
			} catch(e) {
				write(e.description)
			}
		} else var rs = this.execute(sql);

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

	// Update
	this.update = function(table, value, where) {
		if (!this.opened) this.open();
		DBAccess.executeCount += 1;

		var sql = "UPDATE [" + table + "] SET ";
		if (value.constructor == String) sql += value;
		else {
			var e = value.getExpandoNames();
			for (var i = 0; i < e.length; i++) {
				sql += "[" + e[i] + "]=";
				sql += getSQLStr(value[e[i]]) + ", ";
			}
			sql = sql.slice(0, -2);
		}
		if (where) sql += " WHERE " + where;

		return this.execute(sql);
	}

	// Insert
	this.insert = function(table, value, returnRecord) {
		if (!this.opened) this.open();
		DBAccess.executeCount += 1;

		if (returnRecord) {
			var rs = this.createRecordSet();
			rs.Open("SELECT * FROM [" + table + "]", conn, 1, 3);
			rs.AddNew();
			var e = value.getExpandoNames();
			for (var i = 0; i < e.length; i++) {
				if (value[e[i]] && value[e[i]].constructor == String) rs(e[i]) = this.checkSQL(value[e[i]]);
				else if (value[e[i]] && value[e[i]].constructor == Date) rs(e[i]) = new Date(value[e[i]].format("yyyy/MM/dd HH:mm:ss", 0)).getVarDate();
				else rs(e[i]) = value[e[i]];
			}
			rs.Update();
			return new Record(rs).item();
		} else {
			var sql = "INSERT INTO [" + table + "] (", valueStr = "";
			var e = value.getExpandoNames();
			for (var i = 0; i < e.length; i++) {
				sql += "[" + e[i] + "], ";
				valueStr += getSQLStr(value[e[i]]) + ", ";
			}
			sql = sql.slice(0, -2) + ") VALUES (" + valueStr.slice(0, -2) + ")";

			return this.execute(sql);
		}
	}

	// Delete
	this.del = function(table, where, range) {
		if (!this.opened) this.open();
		DBAccess.executeCount += 1;

		var sql = "DELETE " + (range? range: "*") + " FROM [" + table + "]";
		if (where) sql += " WHERE " + where;

		return this.execute(sql);
	}

	this.getConn = function() {
		return conn;
	}

	this.beginTrans = function() {
		conn.BeginTrans();
	}

	this.commitTrans = function() {
		conn.CommitTrans();
	}

	this.rollbackTrans = function() {
		conn.RollbackTrans();
	}

	this.endTrans = function() {
		this.hasError? this.rollbackTrans() : this.commitTrans();
	}

	// Check SQL
	this.checkSQL = function(str) {
		return str.replace(/\'/ig, "''");
	}

	// Record GMT Time
	this.checkDate = function(date) {
		return date.format("yyyy/MM/dd HH:mm:ss", 0);
	}
}
DBAccess.executeCount = 0;
</script>
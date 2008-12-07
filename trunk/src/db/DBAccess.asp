<!--#include file="RecordSet.asp" -->
<!--#include file="Record.asp" -->
<script language="javascript" runat="server">
function DBAccess() {
	var conn;

	this.dbPath = "";
	this.opened = false;
	this.hasError = false;
	this.executes = [];
}

// Insert different type
DBAccess.getSQLStr = function(value) {
	if (value === undefined) return;
	if (value === null) return "NULL";
	switch (value.constructor) {
		case Boolean: return value? "TRUE" : "FALSE";
		case Number: return value.toString();
		case String: return "'" + value.replace(/\'/ig, "''") + "'";
		case Date: return "#" + value.format("yyyy/MM/dd HH:mm:ss", 0) + "#";
	}
}

// Create record set
DBAccess.prototype.createRecordSet = function() {
	try {
		return Server.CreateObject("ADODB.RecordSet");
	} catch(e) {
		throw new Error(0, "Can't create DB Recordset, you need ADODB.Recordset object.");
	}
}

DBAccess.prototype.getConnection = function() {
	return this._conn;
}

// Check SQL
DBAccess.prototype.checkSQL = function(str) {
	return str.replace(/\'/ig, "''");
}

// Open
DBAccess.prototype.open = function() {
	try {
		this._conn = Server.CreateObject("ADODB.Connection");
	} catch(e) {
		throw new Error(0, "Can't create DB Connection, you need ADODB.Connection object.");
	}
	try {
		this._conn.ConnectionString = "Provider = Microsoft.Jet.OLEDB.4.0; Data Source=" + this.dbPath;
		this._conn.Open();
	} catch(e) {
		throw new Error(0, "Database Connection failure.");
	}
	this.opened = true;
}

// Close
DBAccess.prototype.close = function() {
	if (!this.opened) return;

	try {
		this._conn.Close();
	} catch(e) {
		throw new Error(0, "Close database connection error.");
	}
	delete this._conn;
	this.opened = false;
}

// Execute
DBAccess.prototype.execute = function(sql) {
	if (!this.opened) this.open();

	try {
		return this._conn.Execute(sql, 0, 0x0001);
	} catch(e) {
		write(sql)
		write(e.description)
	}
}

// Query by SQL
DBAccess.prototype.query = function(sql, length, currentPage, outVbArr) {
	if (!this.opened) this.open();

	if (length && currentPage) {
		var rs = this.createRecordSet();
		try {
			rs.Open(sql, this._conn, 1, 1);
		} catch(e) {
			write(e.description)
		}
	} else var rs = this.execute(sql);

	if (length && currentPage) {
		rs.PageSize = length;
		if (!rs.BOF && !rs.EOF) rs.AbsolutePage = currentPage;
	}

	this.executes.push(sql);

	if (!outVbArr) {
		if (length == 1) {
			if (rs.BOF && rs.EOF) return;
			return new Record(rs).item();
		} else {
			var records = new RecordSet(rs);
			return records.atEnd()? null : records;
		}
	} else {
		this.recordCount = rs.recordCount;
		return (rs.BOF && rs.EOF)? null : rs.GetRows();
	}
}

// Update
DBAccess.prototype.update = function(table, map, where) {
	if (!this.opened) this.open();

	var sql = "UPDATE [" + table + "] SET ";
	if (map.constructor == String) sql += map;
	else {
		map.forEach(function(value, name) {
			if (value !== undefined) {
				sql += "[" + name + "]=";
				sql += DBAccess.getSQLStr(value) + ", ";
			}
		});
		sql = sql.slice(0, -2);
	}
	if (where) sql += " WHERE " + where;

	return this.execute(sql);
}

// Insert
DBAccess.prototype.insert = function(table, map, returnRecord) {
	if (!this.opened) this.open();

	if (returnRecord) {
		var rs = this.createRecordSet();
		rs.Open("SELECT * FROM [" + table + "]", this._conn, 1, 3);
		rs.AddNew();
		map.forEach(function(value, name) {
			if (value !== undefined) {
				if (value.constructor == String) rs(name) = this.checkSQL(value);
				else if (value && value.constructor == Date) rs(name) = new Date(value.format("yyyy/MM/dd HH:mm:ss", 0)).getVarDate();
				else rs(i) = value;
			}
		});
		rs.Update();
		return new Record(rs).item();
	} else {
		var sql = "INSERT INTO [" + table + "] (", valueStr = "";
		map.forEach(function(value, name) {
			if (value !== undefined) {
				sql += "[" + name + "], ";
				valueStr += DBAccess.getSQLStr(value) + ", ";
			}
		});
		sql = sql.slice(0, -2) + ") VALUES (" + valueStr.slice(0, -2) + ")";

		return this.execute(sql);
	}
}

// Delete
DBAccess.prototype.del = function(table, where, range) {
	if (!this.opened) this.open();

	var sql = "DELETE " + (range? range: "*") + " FROM [" + table + "]";
	if (where) sql += " WHERE " + where;

	return this.execute(sql);
}

DBAccess.prototype.doTrans = function(callback) {
	if (!callback) return;

	this._conn.BeginTrans();
	callback();
	if (this._conn.Errors.Count > 0) {
		this._conn.Errors.Clear();
		this._conn.RollbackTrans();
	} else this._conn.CommitTrans();
}
</script>
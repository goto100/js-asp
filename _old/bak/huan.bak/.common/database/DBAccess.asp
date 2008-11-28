<!--#include file="Record.asp" -->
<!--#include file="RecordCollection.asp" -->
<script language="javascript" runat="server">
function DBAccess(dbPath) {

	// Open
	// 打开数据库连接
	this.open = function()
	{
		try
		{
			conn = new ActiveXObject("ADODB.Connection");
		}
		catch(e)
		{
			throw new Error(0, "Can't create DB Connection, you need ADODB.Connection object.");
		}
		try
		{
			conn.ConnectionString = "Provider = Microsoft.Jet.OLEDB.4.0; Data Source=" + dbPath;
			conn.Open();
		}
		catch(e)
		{
			throw new Error(0, "Database Connection failure.");
		}
		opened = true;
	}

	// Close
	// 关闭数据库连接
	this.close = function()
	{
		if (!opened) return;
		try
		{
			conn.Close();
		}
		catch(e)
		{
			throw new Error(0, "Close database connection error.");
		}
		delete conn;
		opened = false;
	}

	// Execute
	// 执行SQL语句
	this.execute = function(sql) {
		if (!opened) this.open();

		try {
			return conn.Execute(sql, 0, 0x0001);
		} catch(e) {
			write(sql)
			write(e.description)
		}
	}

	// Query by SQL
	// 查询数据库
	this.query = function(sql, length, currentPage, outVbArr)
	{
		if (!opened) this.open();
		DBAccess.executeCount += 1;

		if (length && currentPage)
		{
			var rs = DBAccess.createRecordSet();
			try
			{
				rs.Open(sql, conn, 1, 1);
			}
			catch(e)
			{
				write(e.description)
			}
		}
		else var rs = this.execute(sql);

		if (length && currentPage)
		{
			rs.PageSize = length;
			if (!rs.BOF && !rs.EOF) rs.AbsolutePage = currentPage;
		}

		if (!outVbArr)
		{
			if (length == 1)
			{
				if (rs.BOF && rs.EOF) return;
				return new Record(rs).item();
			}
			else
			{
				var records = new RecordCollection(rs);
				return records.atEnd()? null : records;
			}
		}
		else
		{
			this.recordCount = rs.recordCount;
			return (rs.BOF && rs.EOF)? null : rs.GetRows();
		}
	}

	// Update
	this.update = function(table, value, where)
	{
		if (!opened) this.open();
		DBAccess.executeCount += 1;

		var sql = "UPDATE [" + table + "] SET ";
		if (value.constructor == String) sql += value;
		else
		{
			for (var i in value) if (value.hasOwnProperty(i))
			{
				sql += "[" + i + "]=";
				sql += getSQLStr(value[i]) + ", ";
			}
			sql = sql.slice(0, -2);
		}
		if (where) sql += " WHERE " + where;

		return this.execute(sql);
	}

	// Insert
	this.insert = function(table, value, returnRecord)
	{
		if (!opened) this.open();
		DBAccess.executeCount += 1;

		if (returnRecord)
		{
			var rs = DBAccess.createRecordSet();
			rs.Open("SELECT * FROM [" + table + "]", conn, 1, 3);
			rs.AddNew();
			for (var i in value)
			{
				if (value[i] && value[i].constructor == String) rs(i) = DBAccess.checkSQL(value[i]);
				else if (value[i] && value[i].constructor == Date) rs(i) = new Date(value[i].format("yyyy/MM/dd HH:mm:ss", 0)).getVarDate();
				else rs(i) = value[i];
			}
			rs.Update();
			return new Record(rs).item();
		}
		else
		{
			var sql = "INSERT INTO [" + table + "] (", valueStr = "";
			for (var i in value) if (value.hasOwnProperty(i))
			{
				sql += "[" + i + "], ";
				valueStr += getSQLStr(value[i]) + ", ";
			}
			sql = sql.slice(0, -2) + ") VALUES (" + valueStr.slice(0, -2) + ")";

			return this.execute(sql);
		}
	}

	// Delete
	this.del = function(table, where, range)
	{
		if (!opened) this.open();
		DBAccess.executeCount += 1;

		var sql = "DELETE " + (range? range: "*") + " FROM [" + table + "]";
		if (where) sql += " WHERE " + where;

		return this.execute(sql);
	}

	this.getConn = function()
	{
		return conn;
	}

	this.beginTrans = function()
	{
		conn.BeginTrans();
	}

	this.commitTrans = function()
	{
		conn.CommitTrans();
	}

	this.rollbackTrans = function()
	{
		conn.RollbackTrans();
	}

	this.endTrans = function()
	{
		hasError? this.rollbackTrans() : this.commitTrans();
	}

	// Insert different type
	function getSQLStr(value)
	{
		if (value == null) return "NULL";
		else if (value.constructor == Boolean) return value? "TRUE" : "FALSE";
		else if (value.constructor == Number) return value.toString();
		else if (value.constructor == String) return "'" + value.replace(/\'/ig, "''") + "'";
		else if (value.constructor == Date) return "#" + value.format("yyyy/MM/dd HH:mm:ss", 0) + "#";
	}

	var conn;
	var opened = false;
	var hasError = false;
}
// Record GMT Time
DBAccess.checkDate = function(date)
{
	return date.format("yyyy/MM/dd HH:mm:ss", 0);
}
// Check SQL
DBAccess.checkSQL = function(str)
{
	return str.replace(/\'/ig, "''");
}
DBAccess.createRecordSet = function()
{
	try
	{
		return new ActiveXObject("ADODB.RecordSet");
	}
	catch(e)
	{
		throw new Error(0, "Can't create DB Recordset, you need ADODB.Recordset object.");
	}
}
DBAccess.executeCount = 0;
</script>
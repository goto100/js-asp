<%
//////////////////////////////////////////////////
// Class Name: DBConn
// Author: ScYui
// Last Modify: 2005/8/3
//////////////////////////////////////////////////

function DBConn(strDBPath, strConnName) {
	if (strConnName) DBConn.connections.push(strConnName);

	////////// Attributes //////////////////////////////

	// Private //////////
	var conn = create();

	// Public //////////
	this.opened = false;
	this.connString = strDBPath;
	try {
		this.dbPath = this.connString;
	}
	catch(e) {
		outputErrorMsg("Database path does not exist.");
	}
	this.recordCount = 0;
	this.returnRecordCount = 0;

	////////// Methods //////////////////////////////
	// Private //////////

	function create() {
		try {
			return new ActiveXObject("ADODB.Connection");
		} catch(e) {
			outputErrorMsg("Can't create DB Connection, you shoule have ADODB.Connection object")
		}
	}

	// Transform VBArray to JSArray
	// This function author is SiC
	function transformArray(arr, labels) {
		var outputArray = [];
		var rows = arr.ubound(2);
		var cols = arr.ubound(1);
		for (var i = 0; i <= rows; i++) {
			outputArray[i] = [];
			for (var j = 0; j <= cols; j++) {
				outputArray[i][labels(j).Name] = arr.getItem(j, i);
			}
		}
		return outputArray;
	}

	// Public //////////

	// Open the connection
	this.open = function() {
		if (!this.opened) {
		try {
			conn.ConnectionString = "Provider = Microsoft.Jet.OLEDB.4.0; Data Source=" + this.dbPath;
			conn.Open()
		}
		catch(e) {
			outputErrorMsg("Database Connection failure.");
		}
		this.opened = true;
		}
	}

	// Close the connection
	this.close = function() {
		if (this.opened) {
			try {
				conn.Close();
			}
			catch(e) {
				outputErrorMsg(e)
			}
			delete conn;
			this.opened = false;
		}
	}

	// Simple execute
	this.exec = function(strSQL) {
		if (!this.opened) this.open();

		try {
			var result = conn.Execute(strSQL);
			if (result != undefined) return result;
		}
		catch(e) {
			outputErrorMsg(e);
		}
	}

	// Query database
	// This function is modified from SiC
	this.query = function(strSQL, intPageSize, intCurrentPage, bRawArray) {
		if (!this.opened) this.open();
		DBConn.debugDatabase.push(strSQL);

		var tmpRS = new ActiveXObject("ADODB.Recordset");
		try {
			if (intPageSize  !=  undefined) {
				tmpRS.Open(strSQL, conn, 1, 1);
			} else { // Only a simple query
				tmpRS = this.exec(strSQL);
			}
		} catch(e) {
			outputErrorMsg(e);
		}

		var result = [];
		if (tmpRS.BOF && tmpRS.EOF) { // Have no records
			this.recordCount = 0;
			this.returnRecordCount = 0;

			DBConn.queryCount++;
			return null;
		} else {
			if (intPageSize  !=  undefined) {
				tmpRS.PageSize = intPageSize;
			} else {
				intPageSize = tmpRS.RecordCount;
			}
			if (intCurrentPage  !=  undefined) {
				if (intCurrentPage <= tmpRS.PageCount) {
					tmpRS.AbsolutePage = intCurrentPage;
				}
				else {
					DBConn.queryCount++;
					return null;
				}
			}
			result = tmpRS.GetRows(intPageSize);
			// Set Record Count for reference
			this.recordCount = tmpRS.RecordCount;
			this.returnRecordCount = result.ubound(2) + 1;
			// Transform Array Demisions
			if (!bRawArray) result = transformArray(result, tmpRS.Fields);
			tmpRS.Close();
			delete tmpRS;

			if (strSQL.indexOf("SELECT TOP 1 ") != -1) result = result[0]; // Only query one record

			DBConn.queryCount++;
			return result;
		}
	}

	// Update database
	this.update = function(strTable, arrValues, strWhere) {
		if (!this.opened) this.open();

		var sqlStr ="UPDATE [" + strTable + "] SET ";
		var e = arrValues.getExpandoNames();
		for (var i = 0; i < e.length; i++) {
			if (arrValues[e[i]] != undefined) {
				sqlStr +=  " [" + e[i] + "]=";
				switch (arrValues[e[i]].constructor) {
				case Boolean:
					sqlStr += arrValues[e[i]] + ", ";
					break;

				case Number:
					sqlStr += parseInt(arrValues[e[i]]) + ", ";
					break;

				case String:
					sqlStr += "'" + arrValues[e[i]].toString().checkSQL() + "', ";
					break;

				case Date:
					sqlStr += "#" + arrValues[e[i]].format() + "#, ";
				}
			}
		}

		sqlStr = sqlStr.slice(0, -2);
		if (strWhere != undefined) {sqlStr += " WHERE " + strWhere;}
		//write(sqlStr);
		this.exec(sqlStr);

		DBConn.debugDatabase.push(sqlStr);

		return true;
	}

	// Insert to database
	this.insert = function(strTable, arrValues) {
		if (!this.opened) this.open();

		var sqlStr = "INSERT INTO [" + strTable + "] (";
		var fields = "", values = "";
		var e = arrValues.getExpandoNames();
		for (var i = 0; i < e.length; i++) {
			if (arrValues[e[i]] != undefined) {
				fields += "[" + e[i] + "], ";
				switch(arrValues[e[i]].constructor) {
					case Boolean:
						values += arrValues[e[i]] + ", ";
						break;

					case Number:
						values += arrValues[e[i]] + ", ";
						break;

					case String:
						values += "'" + arrValues[e[i]].toString().checkSQL() + "', ";
						break;

					case Date:
						values += "#" + arrValues[e[i]].format() + "#, ";
				}
			}
		}
		sqlStr +=  fields.slice(0, -2) + ") VALUES (" + values.slice(0, -2) + ")";
		// write(sqlStr + "<br/>")
		this.exec(sqlStr);

		DBConn.debugDatabase.push(sqlStr);

		return true;
	}

	// del
	this.del = function(strTable, strWhere, strRange) {
		if (!this.opened) this.open();

		var sqlStr = "DELETE " + (strRange? strRange: "*") + " FROM [" + strTable + "] WHERE " + strWhere;
		this.exec(sqlStr);

		DBConn.debugDatabase.push(sqlStr);
	}
}

////////// Static //////////////////////////////
DBConn.connections = [];
DBConn.queryCount = 0;
DBConn.debugDatabase = [];

// Close all DB connection once
DBConn.closeAll = function() {
	for (var i = 0; i < DBConn.connections.length; i++) {
		eval(DBConn.connections[i] + ".close()");
	}
}

// Check database connection
DBConn.check = function(strPath) {
	var conn = new ActiveXObject("ADODB.Connection");
	try {
		conn.ConnectionString = "Provider = Microsoft.Jet.OLEDB.4.0; Data Source=" + strPath;
		conn.Open();
	} catch(e) {
		return false;
	}
	return true;
}

%>
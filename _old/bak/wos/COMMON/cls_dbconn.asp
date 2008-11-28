<%
////////////////////////////////////////////////////////////
// Class DBConn
//
// Last modify: 2005/6/20
// Author: ScYui
//
// Attributes: opened, connString, dbPath
// Methods: open, close, query, exec, update, insert
////////////////////////////////////////////////////////////

function DBConn(strDBPath, strConnName) {
	if (strConnName) DBConn.connections.push(strConnName);

	////////// Attributes //////////////////////////////
	// Private //////////
	var conn = new ActiveXObject("ADODB.Connection");

	// Public //////////
	this.opened = false;
	this.connString = strDBPath;
	try {
		this.dbPath = Server.MapPath(this.connString);
	}
	catch(e) {
		outputErrorMsg("Database path does not exist.")
	}

	////////// Methods //////////////////////////////
	// Private //////////

	// Private - RS Array Transformation Helper Function ---------------------
	// I don't like the default style of the return array of GetRows
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

	// open
	this.open = function() {
		if (!this.opened) {
		try {
			conn.ConnectionString = "Provider = Microsoft.Jet.OLEDB.4.0; Data Source=" + this.dbPath;
			conn.Open();
		}
		catch(e) {
			outputErrorMsg("Database Connection failure.");
		}
		this.opened = true;
		}
	}

	// close
	this.close = function() {
		if (this.opened) {
			try {
				conn.Close();
			}
			catch(e) {
				outputErrorMsg(e)
			}
			this.opened = false;
		}
	}

	// query
	this.query = function(strSQL, intPageSize, intCurrentPage, bRawArray) {
		if (!this.opened) this.open();

		var tmpRS = new ActiveXObject("ADODB.Recordset");
		try {
			if (intPageSize  !=  undefined) {
				tmpRS.Open(strSQL, conn, 1, 1);
			} else {
				tmpRS = conn.Execute(strSQL);
			}
		}
		catch(e) {
			outputErrorMsg(e);
		}

		var result = [];
		if (tmpRS.bof  &&  tmpRS.eof) {
			this.recordCount = 0;
			this.returnRecordCount = 0;
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
				else return null;
			}
			result = tmpRS.GetRows(intPageSize);
			// Set Record Count for reference
			this.recordCount = tmpRS.RecordCount;
			this.returnRecordCount = result.ubound(2) + 1;
			// Transform Array Demisions
			if (!bRawArray) result = transformArray(result, tmpRS.Fields);
			tmpRS.Close();
			delete tmpRS;

			DBConn.queryCount++;
			DBConn.debugDatabase.push(strSQL);

			if (strSQL.indexOf("SELECT TOP 1 ") != -1) result = result[0];

			return result;
		}
	}


	// update
	this.update = function(strTable, arrValue, strWhere) {
		var strSQL ="UPDATE " + strTable + " SET ";
		var e = arrValue.getExpandoNames();
		for (var i = 0; i < e.length; i++) {
			if (arrValue[e[i]] != undefined) {
				strSQL +=  " " + e[i] + "=";
				switch(arrValue[e[i]].constructor) {
				case Boolean:
					strSQL +=  arrValue[e[i]] + ", ";
					break;

				case Number:
					strSQL +=  checkInt(arrValue[e[i]]) + ", ";
					break;

				case String:
					strSQL +=  "'" + checkStr(arrValue[e[i]]) + "', ";
					break;

				case Date:
					strSQL +=  "#" + getDateTimeString("YY-MM-DD hh:ii:ss", arrValue[e[i]]) + "#, ";
				}
			}
		}
		strSQL = strSQL.slice(0, -2);
		if (strWhere  !=  undefined) {strSQL +=  " WHERE " + strWhere;}
		DBConn.debugDatabase.push(strSQL);

		this.exec(strSQL);
		return true;
	}


	// insert
	this.insert = function(strTable, arrValue) {
		var strSQL = "INSERT INTO " + strTable + " (";
		var strFields = "", strValues = "";
		var e = arrValue.getExpandoNames();
		for (var i = 0; i < e.length; i++) {
			if (arrValue[e[i]] != undefined) {
				strFields +=  e[i] + ", ";
				switch(arrValue[e[i]].constructor) {
					case Boolean:
						strValues +=  arrValue[e[i]] + ", ";
						break;

					case Number:
						strValues +=  checkInt(arrValue[e[i]]) + ", ";
						break;

					case String:
						strValues +=  "'" + checkStr(arrValue[e[i]]) + "', ";
						break;

					case Date:
						strValues +=  "#" + getDateTimeString("YY-MM-DD hh:ii:ss", arrValue[e[i]]) + "#, ";
				}
			}
		}
		strSQL +=  strFields.slice(0, -2) + ") VALUES (" + strValues.slice(0, -2) + ")";
		this.exec(strSQL);

		DBConn.debugDatabase.push(strSQL);

		return true;
	}

	// del
	this.del = function(strTable, strWhere, strRange) {
		var strSQL = "DELETE " + (strRange? strRange: "*") + " FROM " + strTable + " WHERE " + strWhere
		this.exec(strSQL);

		DBConn.debugDatabase.push(strSQL);

	}

	// exec
	this.exec = function(strSQL) {
		if (!strSQL) return false;
		if (!this.opened) this.open();
		try {
			conn.Execute(strSQL);
		}
		catch(e) {
			outputErrorMsg(e);
		}

	}
}

// Static
DBConn.connections = [];
DBConn.queryCount = 0;
DBConn.debugDatabase = [];

// Close all DB connection once
DBConn.closeAll = function() {
	for (var i = 0; i < DBConn.connections.length; i++) {
		eval(DBConn.connections[i] + ".close()");
	}
}
DBConn.checkDBConn = function(strPath) {
	var conn = new ActiveXObject("ADODB.Connection");
	try {
		conn.ConnectionString = "Provider = Microsoft.Jet.OLEDB.4.0; Data Source=" + Server.MapPath(strPath);
		conn.Open();
	} catch(e) {
		return false;
	}
	return true;
}
%>
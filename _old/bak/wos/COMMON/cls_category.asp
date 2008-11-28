<%
////////////////////////////////////////////////////////////
// Class Category
//
// Last modify: 2005/6/20
// Author: ScYui
//
// Attributes: 
// Methods: 
////////////////////////////////////////////////////////////

function Category(objConn, strSheetName) {
	////////// Attributes //////////////////////////////
	// Private //////////
	var conn = objConn;
	var sheetName = strSheetName;

	// Public //////////
	this.id;
	this.name;
	this.description;
	this.intro;
	this.locked = false;
	this.hidden = false;
	this.setting = [];
	this.rootId;
	this.rootOrder;
	this.order;

	////////// Methods //////////////////////////////
	// Private //////////

	// Public //////////

	this.fill = function(arr) {
		this.id = arr["cate_id"];
		this.name = arr["cate_name"];
		this.rootName = arr["cate_rootName"];
		this.description = arr["cate_description"];
		this.intro = arr["cate_intro"];
		this.locked = arr["cate_locked"];
		this.hidden = arr["cate_hidden"];
		if (arr["cate_setting"]) this.setting = arr["cate_setting"].split(", ");
		this.rootId = arr["cate_rootId"];
		this.rootOrder = arr["cate_rootOrder"];
		this.order = arr["cate_order"];
	}

	// Add a category
	this.add = function(arr) {
		if (!arr["cate_name"]) return getLang("bad_request");
	
		// Get the max number of order
		if (arr["cate_rootId"] == 0) {
			var orderMax = conn.query("SELECT MAX(cate_rootOrder) AS orderMax"
				+ " FROM [" + sheetName + "]");
			orderMax = orderMax[0]["orderMax"];
		} else {
			var orderMax = conn.query("SELECT MAX(cate_order) AS orderMax"
				+ " FROM [" + sheetName + "]"
				+ " WHERE cate_rootId=" + arr["cate_rootId"]);
			orderMax = orderMax[0]["orderMax"];
			var rootOrder = conn.query("SELECT TOP 1 cate_rootOrder"
				+ " FROM [" + sheetName + "]"
				+ " WHERE cate_Id=" + arr["cate_rootId"]);
			rootOrder = rootOrder["cate_rootOrder"];
		}
		// New category at last
		var sql = {	"cate_name":arr["cate_name"]
							, "cate_description":arr["cate_description"]
							, "cate_intro":arr["cate_intro"]
							, "cate_locked":arr["cate_locked"]? true:false
							, "cate_hidden":arr["cate_hidden"]? true:false
							, "cate_setting":arr["cate_setting"]
							};
		if (arr["cate_rootId"] == 0) {
			sql["cate_order"] = 0;
			sql["cate_rootOrder"] = orderMax + 1;
			sql["cate_rootId"] = 0;
		} else {
			sql["cate_order"] = orderMax + 1;
			sql["cate_rootOrder"] = rootOrder;
			sql["cate_rootId"] = arr["cate_rootId"];
		}
	
		conn.insert("[" + sheetName + "]", sql);
		return getLang("category") + getLang("add_success");
	}

	// Edit
	this.edit = function(intId, arr) {
		conn.update("[" + sheetName + "]", {"cate_name":arr["cate_name"]
																						, "cate_description":arr["cate_description"]
																						, "cate_intro":arr["cate_intro"]
																						, "cate_locked":arr["cate_locked"]? true:false
																						, "cate_hidden":arr["cate_hidden"]? true:false
																						, "cate_setting":arr["cate_setting"]
																						}, "cate_id=" + intId);
		return getLang("category") + getLang("edit_success");
	}

	// Get a category's infomation
	this.get = function(intId, arr) {
		if (arr) {
			var sql = "SELECT TOP 1 ";
			for (var i = 0; i < arr.length; i++) {
				sql +=  ("cate_" + arr[i] + ", ");
			}
			sql = sql.slice(0, -2);
			sql +=  " FROM [" + sheetName + "]"
				+ " WHERE cate_id=" + intId;
			var tmpA = conn.query(sql);
			if (tmpA != null) {
				this.fill(tmpA);
				return this;
			}
		} else {
			var sql = "SELECT TOP 1 c.*, r.cate_name"
				+ " FROM [" + sheetName + "] AS c, [" + sheetName + "] AS r"
				+ " WHERE c.cate_rootId=r.cate_id"
				+ " AND c.cate_id=" + intId;
			var tmpA = conn.query(sql);
			if (tmpA != null) {
				tmpA["cate_name"] = tmpA["c.cate_name"];
				tmpA["cate_rootName"] = tmpA["r.cate_name"];
				this.fill(tmpA);
				return this;
			} else { // May be a root category
				sql = "SELECT TOP 1 * FROM [" + sheetName + "]"
					+ " WHERE cate_id=" + intId;
				tmpA = conn.query(sql);
				if (tmpA != null) {
					tmpA["cate_rootName"] = getLang("root_category");
					this.fill(tmpA);
					return this;
				}
			}
		}
	}

	this.getAll = function(arr, bRoot) {
		var sql = "SELECT ";
		if (arr) {
			for (var i = 0; i < arr.length; i++) {
				sql +=  ("cate_" + arr[i] + ", ");
			}
			sql = sql.slice(0, -2);
		} else {
			sql +=  "*";
		}
		sql +=  " FROM [" + sheetName + "]";
		if (bRoot) sql +=  " WHERE cate_rootId=0";
		sql +=  " ORDER BY cate_rootOrder, cate_order";
		var tmpA = conn.query(sql);
		if (tmpA != null) {
			var categories = [];
			for (var i = 0; i < tmpA.length; i++) {
				categories[i] = [];
				var e = tmpA[i].getExpandoNames();
				for (var j = 0; j < e.length; j++) {
					categories[i][e[j].replace("cate_", "")] = tmpA[i][e[j]];
				}
				categories[i].setting = {"fullUrl":theCache.setting.sitePath + categories[i].setting};
			}
			return categories;
		}
	}

	this.del = function(intId) {
		var tmpA = conn.query("SELECT TOP 1 cate_rootId, cate_rootOrder, cate_order"
			+ " FROM [" + sheetName + "]"
			+ " WHERE cate_id=" + intId);
		var rootType = tmpA["cate_rootId"] == 0? true:false;
		var emptyOrder = (rootType? tmpA["cate_rootOrder"]:tmpA["cate_order"]);
		if (rootType) {
			conn.exec("UPDATE [" + sheetName + "] SET cate_rootOrder=cate_rootOrder-1"
				+ " WHERE cate_rootOrder>" + emptyOrder);
		} else {
			conn.exec("UPDATE [" + sheetName + "] SET cate_order=cate_order-1"
				+ " WHERE cate_order>" + emptyOrder
				+ " AND cate_rootId=" + tmpA["cate_rootId"]);
		}
		conn.del("[" + sheetName + "]", "cate_id=" + intId + " OR cate_rootId=" + intId);
		return getLang("category") + getLang("delete_success");
	}

	this.move = function(bUp, intId) {
		var isRoot, order, toOrder
		var tmpA = conn.query("SELECT TOP 1 cate_rootId, cate_rootOrder, cate_order"
			+ " FROM [" + sheetName + "]"
			+ " WHERE cate_id=" + intId);
		isRoot = tmpA["cate_rootId"] == 0? true:false;
		if (isRoot) {
			order = tmpA["cate_rootOrder"];
			toOrder = bUp? (tmpA["cate_rootOrder"]-1):(tmpA["cate_rootOrder"] + 1);
		} else {
			var rootId = tmpA["cate_rootId"];
			order = tmpA["cate_order"];
			toOrder = bUp? (tmpA["cate_order"]-1):(tmpA["cate_order"] + 1);
		}
		if (toOrder == 0) return; // min is 0
	
		if (isRoot) {
			// Exchange
			var orderMax = conn.query("SELECT MAX(cate_rootOrder) AS orderMax"
						+ " FROM [" + sheetName + "]");
			orderMax = orderMax[0]["orderMax"];
			if (toOrder>orderMax) return;
			// Move to last first
			conn.update("[" + sheetName + "]", {"cate_rootOrder":orderMax + 1}, "cate_rootOrder=" + toOrder);
			conn.update("[" + sheetName + "]", {"cate_rootOrder":toOrder}, "cate_rootOrder=" + order);
			conn.update("[" + sheetName + "]", {"cate_rootOrder":order}, "cate_rootOrder=" + (orderMax + 1));
		} else {
			var orderMax = conn.query("SELECT MAX(cate_order) AS orderMax"
						+ " FROM [" + sheetName + "]"
						+ " WHERE cate_rootId=" + rootId);
			orderMax = orderMax[0]["orderMax"];
			if (toOrder>orderMax) return;
			// Move to last first
			conn.update("[" + sheetName + "]", {"cate_order":orderMax + 1}, "cate_order=" + toOrder + " AND cate_rootId=" + rootId);
			conn.update("[" + sheetName + "]", {"cate_order":toOrder}, "cate_order=" + order + " AND cate_rootId=" + rootId);
			conn.update("[" + sheetName + "]", {"cate_order":order}, "cate_order=" + (orderMax + 1) + " AND cate_rootId=" + rootId);
		}
	}
}
%>
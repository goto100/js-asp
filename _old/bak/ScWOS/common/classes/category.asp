<!-- #include file = "../../common/classes/dbform.asp" -->
<%
//////////////////////////////////////////////////
// Class Name: Category
// Author: ScYui
// Last Modify: 2005/10/15
//////////////////////////////////////////////////

function Category(conn, page, search, input) {
	////////// Attributes //////////////////////////////
	// Private //////////
	var tableName = "Categories";
	var form = {};

	// Public

	////////// Methods //////////////////////////////
	// Private //////////

	// Fill form when fun
	function fillForm(isEdit, isSubmit) {
		var form = new DBForm();
		form.mode = isEdit? "edit" : "add";

		if (isEdit) form.addItem("sign", "id", "number", true);
		form.addItem(true, "name", "string", true, lang["name_must"]);
		var description = form.addItem(true, "description", "string");
		description.setMaxLength(255, lang["description_long"]);
		form.addItem(true, "intro", "string");
		form.addItem(true, "link", "string");
		if (isEdit) {
			form.addItem(false, "childs_order", "string");
		} else {
			var parentId = form.addItem(true, "parentId", "number", true, lang["parentId_must"]);
			var tmpA = sys.conn.query("SELECT id AS [value], name AS description"
				+ " FROM [" + tableName + "]"
				+ " ORDER BY [rootOrder], [order]");
			tmpA.unshift({"value":0, "description":lang["categroy_first_class"]});
			parentId.setValues(tmpA, lang["parentId_wrong"]);
		}

		if (isSubmit) {
			form.conn = conn;
			form.table = tableName;
			if (!isEdit && parseInt(input.parentId) != 0) {
				var tmpA = sys.conn.query("SELECT TOP 1 rootOrder FROM [" + tableName + "]"
					+ " WHERE id = " + input.parentId);
				form.addSubmit("rootOrder", parseInt(tmpA["rootOrder"]));
			}
		}

		return form;
	}

	// Public //////////

	// Run actions
	this.run = function(newTableName) {
		if (newTableName) tableName = newTableName;
		if (search.add != null) {
			if (input.name) {
				form = fillForm(false, true);

				if (form.submit(input)) page.outputMsg("addSuccess", lang["add_success"]);
				else {
					page.setRoot("add", "form");
					form.addNodeToPage(page.content);
					page.output();
				}
			} else {
				form = fillForm();
				page.setRoot("add", "form");
				form.addNodeToPage(page.content, {"parentId":search.pid});
				page.output();
			}
		} else if (search.edit != null) {
			if (input.id) {
				form = fillForm(true, true);

				if (form.submit(input)) {
					if (input.childs_order) { // Update child categories' order
						var tmpA = sys.conn.query("SELECT id FROM [" + tableName + "]"
							+ " WHERE parentId = " + input.id
							+ " ORDER BY [rootOrder], [order]");
						var orders = input.childs_order.split(", ");
						if (tmpA != null) {
							for (var i = 0; i < tmpA.length; i++) {
								conn.update("Categories", {"order":orders[i]}, "id = " + tmpA[i]["id"]);
							}
						}
					}
					page.outputMsg("editSuccess", lang["edit_success"]);
				} else {
					page.setRoot("edit", "form")
					form.addNodeToPage(page.content);
					page.output();
				}
			} else if (search.id) {
				var sql = "SELECT TOP 1 id, name, description, intro, link";
				sql += " FROM [" + tableName + "] WHERE id = " + search.id;

				var tmpA = sys.conn.query(sql);
				if (tmpA != null) {
					form = fillForm(true);

					page.setRoot("edit", "form")

					form.addNodeToPage(page.content, tmpA);
					page.output();
				} else page.outputMsg("empty", lang["no_category"]);
			}
		} else if (search["delete"] && search.id) {
			var tmpA = sys.conn.query("SELECT id FROM [" + tableName + "] WHERE parentId = " + search.id);
			if (tmpA != null) page.outputMsg("categoryHaveChilds", lang["category_cant_delete"]);
			else {
				conn.del("Categories", "id = " + search.id);
				page.outputMsg("deleteSuccess", lang["delete_success"]);
			}
		} else if (search.id) {
			page.setRoot("category", "show");

			var tmpA = sys.conn.query("SELECT TOP 1 id, name, description, intro, parentId, [order]"
				+ " FROM [" + tableName + "]"
				+ " WHERE id = " + search.id);
			if (tmpA != null) {
				page.content.addAttribute("id", tmpA["id"]);
				page.content.addAttribute("parentId", tmpA["parentId"]);
				page.content.addAttribute("order", tmpA["order"]);
				page.content.addChild("name", null, tmpA["name"]);
				page.content.addChild("description", null, tmpA["description"]);
				page.content.addChild("intro", null, tmpA["intro"]);

				var tmpA2 = sys.conn.query("SELECT id, name, [order]"
					+ " FROM [" + tableName + "]"
					+ " WHERE parentId = " + search.id + ""
					+ " ORDER BY [rootOrder], [order]");
				if (tmpA2 != null) {
					var eleChilds = page.content.addChild("childs");
					for (var i = 0; i < tmpA2.length; i++) {
						eleChilds.addChild("category", {"id":tmpA2[i]["id"]}, tmpA2[i]["name"]);
					}
				}

				page.output();
			} else page.outputMsg("empty", lang["no_category"]);
		} else {
			page.setRoot("categories", "list");
			var tmpA = sys.conn.query("SELECT id, name, description, parentId, [order]"
				+ " FROM [" + tableName + "]"
				+ " ORDER BY [rootOrder], [order]");
			if (tmpA != null) {
				for (var i = 0; i < tmpA.length; i++) {
					var tEle = page.content.addChild("category", {
							"id":tmpA[i]["id"]
						, "parentId":tmpA[i]["parentId"]
						, "order":tmpA[i]["order"]
					});
					tEle.addChild("name", null, tmpA[i]["name"]);
					tEle.addChild("description", null, tmpA[i]["description"]);
				}
			}
			page.output();
		}
	}

}
%>

<!-- #include file = "common.asp" -->
<!-- #include file = "../common/classes/dbform.asp" -->
<%
if (search.add != null) {
	if (input.id) {
		var right = siteRight.getRights(1);
		var form = fillForm(right, false, true);

		if (form.submit(input)) page.outputMsg("addSuccess", lang["add_success"]);
		else {
			page.setRoot("form", "add");
			form.addNodeToPage(page.content);
			page.output();
		}
	} else {
		var right = siteRight.getRights(1);
		var form = fillForm(right);
		page.setRoot("form", "add");
		form.addNodeToPage(page.content);
		page.output();
	}

} else if (search.edit != null) {
	if (input.id) {
		var right = siteRight.getRights(parseInt(input.id));
		if (right) {
			var form = fillForm(right, true, true);

			if (form.submit(input)) page.outputMsg("editSuccess", lang["edit_success"]);
			else {
				page.setRoot("edit", "form")
				form.addNodeToPage(page.content);
				page.output();
			}
		} else page.outputMsg("empty", lang["no_userGroup"]);
	} else if (search.id) {
		var tmpA = sys.conn.query("SELECT TOP 1 id, name, rights FROM [UserGroups]"
			+ " WHERE id = " + search.id);
		if (tmpA != null) {
			var right = siteRight.getRights(parseInt(search.id));
			var e = right.getExpandoNames();
			for (var i = 0; i < e.length; i ++) {
				tmpA["right_" + e[i]] = right[e[i]];
			}

			var form = fillForm(right, true);
			page.setRoot("edit", "form")
			form.addNodeToPage(page.content, tmpA);
			page.output();
		} else page.outputMsg("empty", lang["no_userGroup"]);
	} else page.outputMsg("badRequest");

} else if (search["delete"] != null && search.id) {
	var id = parseInt(search.id);
	if ( id == 1 || id == 2 || id == 3) page.outputMsg("protected", lang["group_protected"]);
	else {
		conn.del("UserGroups", "id = " + id);
		page.outputMsg("deleteSuccess", lang["delete_success"]);
	}

} else if (search.id) {
	page.setRoot("userGroup", "show");
	var tmpA = sys.conn.query("SELECT TOP 1 id, name FROM [UserGroups] WHERE id = " + search.id);
	if (tmpA != null) {
		page.content.addAttribute("id", tmpA["id"]);
		page.content.addChild("name", null, tmpA["name"]);
		page.output();
	} else page.outputMsg("empty", lang["no_userGroup"]);

} else {
	page.setRoot("userGroups", "list");
	var tmpA = sys.conn.query("SELECT id, name FROM [UserGroups]");
	if (tmpA != null) {
		for (var i = 0; i < tmpA.length; i++) {
			var tEle = page.content.addChild("group", {"id":tmpA[i].id}, tmpA[i].name);
		}
	}
	page.output();
}

function fillForm(right, isEdit, isSubmit) {
	var form = new DBForm();
	if (isEdit) form.addItem("sign", "id", "number");
	form.addItem(true, "name", "string", true, lang["name_must"]);
	if (isSubmit) {
		form.conn = conn;
		form.mode = isEdit? "edit" : "add";
		form.table = "UserGroups";

		if (isEdit) form.addSubmit("id", search.id);
	}

	if (isSubmit) {
		var rightsStr = "";
		var e = right.getExpandoNames();
		for (var i = 0; i < e.length; i++) {
			form.addItem(false, "right_" + e[i], typeof(right[e[i]]));
			rightsStr += input["right_" + e[i]]? "1," : "0,";
		}
		rightsStr = rightsStr.slice(0, -1);

		form.addSubmit("rights", rightsStr);
	} else {
		var e = right.getExpandoNames();
		for (var i = 0; i < e.length; i++) {
			form.addItem(false, "right_" + e[i], typeof(right[e[i]]));
		}
	}

	return form;
}
%>
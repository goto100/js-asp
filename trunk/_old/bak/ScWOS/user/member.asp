<!-- #include file = "common.asp" -->
<%
if (search.id) {
	var tmpA = sys.conn.query("SELECT TOP 1 m.id, m.email, m.nickname, m.gender, g.id, g.name"
		+ " FROM [Members] AS m, [UserGroups] AS g"
		+ " WHERE m.groupId = g.id"
		+ " AND m.id = " + search.id);
	if (tmpA != null) {
		page.setRoot("member", "show");
		page.content.addAttribute("id", tmpA["m.id"]);
		page.content.addChild("email", null, tmpA["email"]);
		page.content.addChild("nickname", null, tmpA["nickname"]);
		page.content.addChild("gender", {"id":tmpA["gender"]}, getGender(parseInt(tmpA["gender"])));
		page.content.addChild("group", {"id":tmpA["g.id"]}, tmpA["name"]);
		page.output();
	} else {
		page.outputMsg("empty", lang["no_member"]);
	}

} else {
	var tTable = page.getTable(20);

	var tmpA = sys.conn.query("SELECT m.id, m.email, g.id, g.name"
		+ " FROM [Members] AS m, [UserGroups] AS g"
		+ " WHERE m.groupId = g.id", tTable.size, tTable.current);
	if (tmpA != null) {
		page.setRoot("members", "list");
		tTable.addNodeToPage(page.content, conn.recordCount);
		for (var i = 0; i < tmpA.length; i++) {
			tEle = page.content.addChild("member", {"id":tmpA[i]["m.id"]});
			tEle.addChild("email", null, tmpA[i]["email"]);
			tEle.addChild("group", {"id":tmpA[i]["g.id"]}, tmpA[i]["name"]);
		}
		page.output();
	} else page.outputMsg("badRequest");
}

function getGender(id) {
	switch (id) {
		case 0:
			return lang["gender_serect"];
		case 1:
			return lang["gender_woman"];
		case 2:
			return lang["gender_man"];
	}
}
%>

<!-- #include file = "source/member.asp" -->
<%
switch (page.id) {
	case "edit":
	case "editError":
		page.setRoot("edit");
		var form = page.getForm(dbForm);
		page.output();
		break;

	case "editSuccess":
		page.outputMsg("editSuccess", lang["edit_success"]);
		break;

	case "deleteSuccess":
		page.outputMsg("deleteSuccess", lang["delete_success"]);
		break;

	case "noMember":
		page.outputMsg("empty", lang["no_member"])
		break;

	case "list":
	default:
		var tTable = page.getTable(20);
		page.setRoot("members", "list");
		tTable.addNodeToPage(page.content, members.total);
		for (var i = 0; i < members.length; i++) {
			var eleMember = page.content.addChild("member");
			eleMember.addAttribute("id", members[i].id);
			eleMember.addChild("email", null, members[i].email);
			eleMember.addChild("nickname", null, members[i].nickname);
			eleMember.addChild("gender", {"id":members[i].gender}, getGender(members[i].gender));
			eleMember.addChild("group", {"id":members[i].groupId}, members[i].groupName);
		}
		page.output();
		break;
}

function getGender(id) {
	switch (id) {
		case 0:
			return lang["gender_secret"];
		case 1:
			return lang["gender_female"];
		case 2:
			return lang["gender_male"];
	}
}
%>

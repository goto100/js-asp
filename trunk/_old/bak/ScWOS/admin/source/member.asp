<!-- #include file = "../../common/_common.asp" -->
<%
if (search.edit == "do" && input) {
	var member = sys.getMember(parseInt(input.id));
	var dbForm = member.edit(input);
	if (dbForm == true) page.id = "editSuccess";
	else page.id = "editError";

} else if (search.edit != null && search.id) {
	var member = sys.getMember(parseInt(search.id));
	if (member) {
		var dbForm = member.fillForm();
		page.id = "edit";
	}
	else page.id = "noMember";

} else if (search["delete"] == "do" && search.id) {
	if (sys.deleteMember(parseInt(search.id))) page.id = "deleteSuccess";
	else page.id = "noMember";

} else {
	var members = sys.getMembers(20, search.p? parseInt(search.p) : 1);
	page.id = "list";
}
%>
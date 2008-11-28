<!-- #include file = "common.asp" -->
<!-- #include file = "../common/classes/category.asp" -->
<%
if (search.edit == "do" && input) {

} else if (search.edit != null) {

} else {
	page.setRoot("settings", "list");
	var e = sys.setting.getExpandoNames();
	for (var i = 0; i < e.length; i++) {
		page.content.addChild(e[i], {"type":typeof(cache.setting[e[i]])}, cache.setting[e[i]]);
	}
	page.output();
}
%>
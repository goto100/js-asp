<!-- #include file = "common.asp" -->
<%
var tTable = page.getTable(10);
var sql = "SELECT a.id, a.title, a.author, a.time, c.id, c.name"
	+ " FROM [Articles] AS a, [Categories] AS c"
	+ " WHERE a.cateId = c.id";
if (search.cid) sql += " AND a.cateId = " + search.cid;

var order = "";
switch (search.order) {
	case "id" : order = "a.id"; break;
	case "title" : order = "a.title"; break;
	case "time" : order = "a.time DESC"; break;
	case "author" : order = "a.author"; break;
	case "cate" : order = "c.id"; break;
	default : order = "a.time";
}
sql += " ORDER BY " + order;

var tmpA = artiConn.query(sql, tTable.size, tTable.current);
if (tmpA != null) {
	page.setRoot("articles", "list");
	tTable.addNodeToPage(page.content, artiConn.recordCount);
	if (search.cid) {
		page.content.addAttribute("cateId", search.id);
		page.content.addAttribute("cateName", tmpA[0]["name"]);
		page.content.addAttribute("order", search.order);
	}
	for (var i = 0; i < tmpA.length; i++) {
		var tEle = page.content.addChild("article", {"id":tmpA[i]["a.id"]});
		tEle.addChild("title", null, tmpA[i]["title"]);
		tEle.addChild("category", {"id":tmpA[i]["c.id"]}, tmpA[i]["name"]);
		tEle.addChild("author", null, tmpA[i]["author"]);
		tEle.addChild("publisher", {"id":tmpA[i]["publisherId"]}, tmpA[i]["publisher"]);
		tEle.addChild("time", null, new Date(tmpA[i]["time"]).format());
	}
	page.output();
} else page.outputMsg("badRequest");
%>

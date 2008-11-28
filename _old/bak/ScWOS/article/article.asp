<!-- #include file = "common.asp" -->
<!-- #include file = "common/CLASSES/article.asp" -->
<%
Article.conn = artiConn;

if (search.add == "do" && input) {
	var article = new Article();
	if (Article.add(input)) {
		page.outputMsg("addSuccess", lang["add_success"]);
	} else {
		page.setRoot("add", "form");
		Article.form.addNodeToPage(page.content);
		page.output();
	}

} else if (search.add != null) {
	var form = Article.fillForm();
	page.setRoot("add", "form");
	form.addNodeToPage(page.content);
	page.output();

} else if (search.edit == "do" && input) {
	var article = new Article();
	if (article.edit(input)) {
		page.outputMsg("editSuccess", lang["edit_success"]);
	} else {
		page.setRoot("edit", "form");
		article.form.addNodeToPage(page.content);
		page.output();
	}

} else if (search.edit != null && search["id"]) {
	var form = Article.fillForm(true);
	var tmpA = artiConn.query("SELECT TOP 1 id, cateId, title, author, [from], content, builtPath, builtName, builtType"
		+ " FROM [Articles]"
		+ " WHERE id = " + search.id);
	if (tmpA != null) {
		page.setRoot("edit", "form")
		form.addNodeToPage(page.content, tmpA);
		page.output();
	} else page.outputMsg("empty", lang["no_article"]);

} else if (search["delete"] == "do" && search.id) {

} else if (search["id"]) {
	var article = new Article();
	var tmpA = artiConn.query("SELECT TOP 1 a.id AS id, a.title, a.author, a.from, a.content, a.publisherId, a.publisher, a.time, c.id AS cateId, c.name"
		+ " FROM [Articles] AS a, [Categories] AS c"
		+ " WHERE a.cateId = c.id AND a.id = " + search.id);
	if (tmpA != null) {
		article.fill(tmpA);
		page.setRoot("article", "show");
		page.content.addAttribute("id", article.id);

		// Get previous and next article
		article.getSideArticle();
		if (article.previousArticle) {
			page.content.addAttribute("previousId", article.previousArticle.id);
			page.content.addAttribute("previousTitle", article.previousArticle.title);
		}
		if (article.nextArticle) {
			page.content.addAttribute("nextId", article.nextArticle.id);
			page.content.addAttribute("nextTitle", article.nextArticle.title);
		}

		page.content.addChild("title", null, article.title);
		page.content.addChild("category", {"id":article.category.id}, article.category.name);
		page.content.addChild("author", null, article.author);
		page.content.addChild("from", null, article.from);
		page.content.addChild("content", null, article.content);
		page.content.addChild("publisher", {"id":article.publisher.id}, article.publisher.name);
		page.content.addChild("time", null, article.time);
		page.output();
	} else page.outputMsg("empty", lang["no_article"]);
} else page.redirect("index.asp");
%>

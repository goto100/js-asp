<!--#include file="common.asp" -->
<!--#include file="default.source.asp" -->
<%
function MainOutputer(controller) {
	function makeCategoryElement(element, category) {
		var eleCategory, i;

		for (i = 0; i < category.length; i++) {
			eleCategory = element.addChild("category", {name: category[i].name}, {id: category[i].id});
			if (category[i]) makeCategoryElement(eleCategory, category[i]);
		}
	}

	this.outputAddForm = function(value, category) {
		var page = controller.getPage(new FormPage("add", value));
		page.content.addInfo("article").addForms("cateId", "title", "content");
		page.content.addInfo("save").addForms("action");
		var eleCategory = page.content.addChild("category");
		makeCategoryElement(eleCategory, category);

		page.output();
	}

	this.outputEditForm = function(article, category) {
		var page = controller.getPage(new FormPage("edit", article));
		page.setForm({
			article: ["id", {category: ["id"]}, "title", "postTime", "content"],
			update: ["action"]
		});
		var eleCategory = page.content.addChild("category");
		makeCategoryElement(eleCategory, category);

		page.output();
	}

	this.outputArticle = function(article) {
		var page = controller.getPage(new Page("article"));
		page.content.addAttribute("id", article.id);
		page.content.addChild("category", {name: article.category.name}, {id: article.category.id});
		page.content.addChild("title", article.title);
		page.content.addChild("postTime", article.postTime);
		page.content.addXMLChild("content", ubb(article.content));

		page.output();
	}

	this.builtArticle = function() {
		
	}

	this.outputArticles = function(articles) {
		var page, eleArticle, i;

		page = controller.getPage(new ListPage("articles", articles));
		if (articles.category) page.content.addChild("category", articles.category.name, {id: articles.category.id});
		for (i = 0; i < articles.length; i++) {
			eleArticle = page.addItem({id: articles[i].id});
			eleArticle.addChild("title", articles[i].title);
			eleArticle.addChild("category", articles[i].category.name, {id: articles[i].category.id});
			eleArticle.addChild("postTime", articles[i].postTime);
		}

		page.output();
	}

	this.outputArticlesRSS = function(articles) {
		var page = controller.getPage(new RSSPage(articles, "title", "id", "content"));

		page.output();
	}
}
function blockquote(str, content) {
	if (str.indexOf("</blockquote>") > -1) content = content.replace(/<blockquote>((\s|\S)+?)<\/blockquote>/ig, blockquote);
	return content;
}
function ubb(str) {
	//str = str.replace(/&lt;(.+?)(( +.+=\".*\")*)&gt;(.*?)&lt;\/\1&gt;/ig, "<$1$2>$4</$1>");
	//str = str.replace(/<(.*?)>/ig, "&lt;$1&gt;");
	//str = str.replace(/&lt;(.+?)(( .+=\".*\")*)&gt;(.*?)&lt;\/\1&gt;/ig, "<$1$2>$4</$1>");
	str = str.replace(/<blockquote>((\s|\S)+?)<\/blockquote>/ig, blockquote);

	return str;
}

%>
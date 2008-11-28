<!--#include file="../../common.asp" -->
<!--#include file="default.source.asp" -->
<%
function MainOutputer() {
	function makeCategoryElement(element, category) {
		for (var i = 0; i < category.length; i++) {
			var eleCategory = element.addChild("category", {name: category[i].name}, {id: category[i].id});
			if (category[i]) makeCategoryElement(eleCategory, category[i]);
		}
	}

	this.outputTree = function(nodes) {
		var page = controller.getPage(new Page("category"));
		makeCategoryElement(page.content, nodes);

		page.output();
	}

	this.outputEditForm = function(value) {
		var page = controller.getPage(new FormPage("edit", value));
		page.content.addInfo("category").addForms("id", "name", "url");

		page.output();
	}

	this.outputAddForm = function(value, category) {
		var page = controller.getPage(new FormPage("add", value));
		page.content.addInfo("category").addForms("parentId", "name", "url");
		page.content.addInfo("save").addForms("action");
		var eleCategory = page.content.addChild("category");
		makeCategoryElement(eleCategory, category);

		page.output();
	}
}
%>
<!--#include file="../../common.asp" -->
<!--#include file="default.source.asp" -->
<%
function MainOutputer(controller) {
	function makeCategoryNode(pageNode, nodes) {
		var i;

		for (i = 0; i < nodes.length; i++) {
			var eleCategory = pageNode.addChild("category", null, {id: nodes[i].id, name: nodes[i].name});
			if (nodes[i]) makeCategoryNode(eleCategory, nodes[i]);
		}
	}

	this.outputTree = function(nodes) {
		var page;

		page = controller.getPage(new Page("category"));
		makeCategoryNode(page.content, nodes);

		page.output();
	}

	this.outputEditForm = function(value) {
		var page;

		page = controller.getPage(new FormPage("edit", value));
		page.content.addInfo("category").addForms("id", "name", "description", "articleCount");

		page.output();
	}

	this.outputAddForm = function(value, category) {
		var page, eleCategory;

		page = controller.getPage(new FormPage("add", value));
		page.content.addInfo("category").addForms("parentId", "name", "description");
		page.content.addInfo("save").addForms("action");
		eleCategory = page.content.addChild("category");
		makeCategoryNode(eleCategory, category);

		page.output();
	}
}
%>
<!--#include file="../../common.asp" -->
<!--#include file="default.source.asp" -->
<%
function MainOutputer(controller) {
	this.outputList = function(userGroups) {
		var page, eleUserGroup;

		page = controller.getPage(new ListPage("userGroups", userGroups));
		for (i = 0; i < userGroups.length; i++) {
			eleUserGroup = page.addItem();
			eleUserGroup.addAttribute("id", userGroups[i].id);
			eleUserGroup.addChild("name", userGroups[i].name);
			eleUserGroup.addChild("right", userGroups[i].right);
			eleUserGroup.addChild("userCount", userGroups[i].userCount);
		}

		page.output();
	}

	this.outputAddForm = function(value, userGroups) {
		var i, page, eleUserGroups, eleUserGroup;

		page = controller.getPage(new FormPage("add", value));
		page.content.addInfo("userGroup").addForms("name", "rightFrom");
		eleUserGroups = page.content.addChild("userGroups");

		for (i = 0; i < userGroups.length; i++) {
			eleUserGroup = eleUserGroups.addChild("userGroup", null, {id: userGroups[i].id});
			eleUserGroup.addChild("name", userGroups[i].name);
			eleUserGroup.addChild("right", userGroups[i].right);
			eleUserGroup.addChild("userCount", userGroups[i].userCount);
		}

		page.output(); 
	}

	this.outputEditForm = function(value) {
		var page;

		page = controller.getPage(new FormPage("edit", value));
		page.content.addInfo("userGroup").addForms("id", "name", "viewSite", "administer", "viewMembers", "viewUsers");

		page.output();
	}
}
%>
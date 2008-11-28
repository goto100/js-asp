<!--#include file="../../common.asp" -->
<!--#include file="default.source.asp" -->
<%
function MainOutputer(controller) {

	this.outputMembers = function(members) {
		var page = controller.getPage(new ListPage("members", members));
		for (var i = 0; i < members.length; i++) {
			var eleMember = page.addItem({id: members[i].id});
			eleMember.addChild("userId", members[i].userId);
			eleMember.addChild("nickname", members[i].nickname);
			eleMember.addChild("regTime", members[i].regTime);
			eleMember.addChild("lastVisitTime", members[i].lastVisitTime);
			eleMember.addChild("lastIP", members[i].lastIP);
		}

		page.output();
	}

	this.outputAddForm = function(value, userGroups) {
		var page, eleUserGroups, i;

		page = controller.getPage(new FormPage("add", value));
		page.content.addInfo("member").addForms("userId", "groupId", "password", "rePassword", "nickname", "secQuestion", "secAnswer");
		eleUserGroups = page.content.addChild("userGroups");
		for (i = 0; i < userGroups.length; i++) eleUserGroups.addChild("userGroup", userGroups[i].name, {id: userGroups[i].id});

		page.output();
	}

	this.outputEditForm = function(value, userGroups) {
		var page, eleUserGroups, i;

		page = controller.getPage(new FormPage("edit", value));
		page.content.addInfo("member").addForms("id", "userId", "groupId", "password", "rePassword", "nickname", "secQuestion", "secAnswer");
		eleUserGroups = page.content.addChild("userGroups");
		for (i = 0; i < userGroups.length; i++) eleUserGroups.addChild("userGroup", userGroups[i].name, {id: userGroups[i].id});

		page.output();
	}
}
%>
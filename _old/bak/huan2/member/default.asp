<!--#include file="../common.asp" -->
<!--#include file="default.source.asp" -->
<%
function MainOutputer(controller) {

	this.outputMembers = function(members) {
		var i, page;

		page = controller.getPage(new ListPage("members", members));
		for (i = 0; i < members.length; i++) {
			var eleMember = page.addItem({id: members[i].id});
			eleMember.addChild("userId", members[i].userId);
			eleMember.addChild("nickname", members[i].nickname);
			eleMember.addChild("regTime", members[i].regTime);
			eleMember.addChild("lastVisitTime", members[i].lastVisitTime);
			eleMember.addChild("lastIP", members[i].lastIP);
		}

		page.output();
	}

	this.outputMember = function(member) {
		var page;

		page = controller.getPage(new Page("member"));
		page.content.addAttribute("id", member.id);
		page.content.addChild("nickname", member.nickname);

		page.output();
	}
}
%>
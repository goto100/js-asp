<!--#include file="../common.asp" -->
<!--#include file="default.source.asp" -->
<%
function MainOutputer(controller) {
	this.outputUsers = function(users) {
		var eleUser, page;

		page = controller.getPage(new ListPage("users", users));
		for (eleUser, i = 0; i < users.length; i++) {
			eleUser = page.addItem({currentUser: users[i].currentUser, id: users[i].id});
			eleUser.addChild("nickname", users[i].nickname);
			eleUser.addChild("ip", users[i].ip);
			eleUser.addChild("visitTime", users[i].visitTime);
			eleUser.addChild("onlineTime", parseInt(users[i].onlineTime / 60000));
		}

		page.output();
	}
}
%>
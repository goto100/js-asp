<!--#include file="../common.asp" -->
<!--#include file="default.source.asp" -->
<%
function MainOutputer(controller) {
	this.outputInfo = function(info) {
		var page = controller.getPage(new Page("systemInfo"));
		page.content.addChild("now", info.now);
		page.content.addChild("version", info.version);
		page.content.addChild("updateDate", info.updateDate);
		page.content.addChild("userCount", info.userCount);
		page.content.addChild("memberCount", info.memberCount);
		page.content.addChild("visitorCount", info.visitorCount);

		page.output();
	}
}
%>
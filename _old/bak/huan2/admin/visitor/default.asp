<!--#include file="../../common.asp" -->
<!--#include file="default.source.asp" -->
<%
function MainOutputer(controller) {
	this.outputList = function(visitors) {
		var page, i, eleVisitor;

		page = controller.getPage(new ListPage("visitors", visitors));
		for (i = 0; i < visitors.length; i++) {
			eleVisitor = page.addItem();
			eleVisitor.addChild("ip", visitors[i].ip);
			eleVisitor.addChild("time", visitors[i].time);
			eleVisitor.addChild("os", visitors[i].os);
			eleVisitor.addChild("browser", visitors[i].browser);
			eleVisitor.addChild("referer", visitors[i].referer);
			eleVisitor.addChild("target", visitors[i].target);
		}

		page.output();
	}
}
%>
<!--#include file="../common.asp" -->
<!--#include file="default.source.asp" -->
<%
function MainOutputer(controller) {
	this.outputInfo = function() {
		var page = controller.getPage(new Page("systemInfo"));

		page.output();
	}
}
%>
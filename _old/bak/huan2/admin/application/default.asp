<!--#include file="../../common.asp" -->
<!--#include file="default.source.asp" -->
<%
function MainOutputer(controller) {
	this.outputApplications = function(applications) {
		var page = controller.getPage(new ListPage("applications", applications));

		for(var eleApplication, i = 0; i < applications.length; i++) {
			eleApplication = page.addItem({id: applications[i].id});
			eleApplication.addChild("path", applications[i].path);
		}

		page.output();
	}

	this.outputAddForm = function() {

	}
}
%>
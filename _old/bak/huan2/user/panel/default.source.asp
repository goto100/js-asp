<%
function Main() {
	var actEdit = controller.addAction(new FormAction, "edit");
	var actUpdate = controller.addAction(new DBAction, "update");

	actEdit.action = function() {
		outputer.outputEditForm(this.getValue());
	}

	actUpdate.action = function() {
		
	}
}
%>
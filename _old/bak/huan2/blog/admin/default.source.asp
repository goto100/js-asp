<%
function Main() {
	var actInfo = controller.addAction(new Action);

	actInfo.action = function() {
		outputer.outputInfo();
	}
}
%>
<!--#include file="base2.asp" -->
<!--#include file="web/Controller.asp" -->
<!--#include file="web/Action.asp" -->
<script language="javascript" runat="server">
base2.JavaScript.bind(this);
eval(base2.namespace);

function write(str) {
	Response.Write(str);
}
function writeln(str) {
	Response.Write((str? str : "") + "<br />");
}
var test = {};
test.start = function() {
	test.now = Date.now();
}
test.end = function() {
	writeln(Date.now() - test.now + "ms");
}
</script>

<!--#include file="base2.asp" -->
<!--#include file="web/Controller.asp" -->
<!--#include file="web/Action.asp" -->
<script language="javascript" runat="server">
eval(base2.namespace);
JavaScript.bind(this);

function write(str) {
	Response.Write(str);
}
function writeln(str) {
	Response.Write(str + "<br />");
}
function writebin(bin) {
	write("<pre>");
	Response.BinaryWrite(bin);
	write("</pre>");
}
var test = {};
test.start = function() {
	test.now = Date.now();
}
test.end = function(str) {
	if (!str) str = "";
	writeln(str + (Date.now() - test.now) + "ms");
	test.now = Date.now();
}
</script>

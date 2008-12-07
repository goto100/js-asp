<!--#include file="base2.asp" -->
<!--#include file="web/Controller.asp" -->
<!--#include file="web/Action.asp" -->
<script language="javascript" runat="server">
base2.JavaScript.bind(this);
eval(base2.namespace);

function write(str, bin) {
	bin? Response.BinaryWrite(str) : Response.Write(str);
}
function writeln(str, bin) {
	if (bin) {
		Response.BinaryWrite((str? str : ""));
		Response.Write("<br />");
	} else Response.Write((str? str : "") + "<br />");
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

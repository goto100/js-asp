<%@LANGUAGE="JAVASCRIPT" CODEPAGE="65001"%>
<!--#include file="common.asp"-->
<script language="javascript" runat="server">
var fso = Server.CreateObject("Scripting.FileSystemObject");
var file = fso.OpenTextFile(Server.MapPath("/js-asp/winzheng.xml"), 1);
var xml = file.ReadAll();

function closeXML(xml) {
	xml = xml.substr(0, xml.lastIndexOf("<"));
	var tags = [];
	var patt = new RegExp("<([/a-z][a-z0-9]*)[^>]*?(\/?)>", "ig"); // 所有非自关闭标签
	var result;
	var tag;
	while ((result = patt.exec(xml)) != null) {
		if (!result[2]) tags.push(result[1]);
	}
	for (var i = 0; i < tags.length; i++) {
		while ("/" + tags[i] ==  tags[i + 1]) {
			tags.splice(i, 2);
			i--;
		}
	}
	writeln(tags)
	tags.reverse();
	for (var i = 0; i < tags.length; i++) {
		xml += "</" + tags[i] + ">";
	}
	return xml;
}


write("<textarea style='width; 100%; height: 200px'>" + closeXML(xml) + "</textarea>");
</script>

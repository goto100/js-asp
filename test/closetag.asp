<%@LANGUAGE="JAVASCRIPT" CODEPAGE="65001"%>
<!--#include file="common.asp"-->
<script language="javascript" runat="server">
var fso = Server.CreateObject("Scripting.FileSystemObject");
var file = fso.OpenTextFile(Server.MapPath("/js-asp/a.xml"), 1);
var xml = file.ReadAll();

function closeXML(xml) {
	var last = xml.lastIndexOf("<");
	if (last > xml.lastIndexOf(">")) xml = xml.substr(0, last); // 去除末尾未结束标签
	var tags = [];
	var patt = new RegExp("<([/a-z][a-z0-9]*)[^>]*?(\/?)>", "ig"); // 所有标签
	var result;
	var tag;
	while ((result = patt.exec(xml)) != null) {
		if (!result[2]) { // 非自关闭标签
			if (result[1].substring(1) == tags[tags.length - 1]) tags.pop();
			else tags.push(result[1]);
		}
	}
	tags.reverse();
	for (var i = 0; i < tags.length; i++) {
		xml += "</" + tags[i] + ">";
	}
	return xml;
}


write(closeXML(xml));
</script>

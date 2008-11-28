<%@LANGUAGE="JAVASCRIPT" CODEPAGE="65001"%>
<!--#include file="Pnglet.asp" -->
<%
Response.Expires = -9999;
Response.AddHeader("Pragma", "no-cache");
Response.AddHeader("Cache-Control", "no-cache");
Response.ContentType = "image/png";

var pnglet = new Pnglet(32, 32, 8);
pnglet.line(pnglet.color(255, 0, 0), 2, 2, 32, 16);
var datas = pnglet.output();
for (var i = 0; i < datas.length; i += 2) {
	Response.BinaryWrite(String.fromCharCode(datas[i] + (datas[i + 1] << 8)));
}
%>
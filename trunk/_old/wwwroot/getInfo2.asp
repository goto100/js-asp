<%@LANGUAGE="JAVASCRIPT" CODEPAGE="65001"%>
<%
Session.Timeout = 900;
Server.ScriptTimeout = 900;
function write(str) {
	Response.Write(str);
}

var infos = []

var xmlHttp = new ActiveXObject("Microsoft.XMLHttp");

for (var i = 0; i < 49; i++)
{
	xmlHttp.open("GET", "http://www.locoso.com/" + (i + 1) +"_110000/_060201000000/", false);
	//xmlHttp.setRequestHeader("Content-Length", stra.length);
	//xmlHttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
	xmlHttp.send(null);

	var links = xmlHttp.responseText.match(/\<\/font\>\<a href\=\"\/detail\/(.+)\/\"/ig);
	if (!links) write(i+1)
	else for (var j = 0; j < links.length; j++)
	{
		var info = {};
		xmlHttp.open("GET", "http://www.locoso.com" + links[j].slice(16, links[j].length - 1), false);
		xmlHttp.send(null);
		xmlHttp.responseText.match(/邮　编：\<\/strong\>\<\/td\>\s+\<td\> \<font color\=\#000000\>(.*)\<\/font\>/ig);
		info.postCode = RegExp.$1;
		xmlHttp.responseText.match(/地　址：\<\/strong\>\<\/td\>\s+\<td\>  \<font color\=\#000000\>(.*)\<\/font\>\<font color\=\#000000\>(.+)\<\/font\>/ig);
		info.address = RegExp.$1 + " " + RegExp.$2;
		xmlHttp.responseText.match(/公司名称：\<\/strong\>\<\/td\>\s+\<td\> \<font color\=\#000000\>(.*?)\<\/font\>/ig);
		info.company = RegExp.$1;

		infos.push(info);
		xmlHttp.abort();
	}
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>无标题文档</title>
</head>

<body>
<table width="100%" border="1" cellspacing="0" cellpadding="10">
<%
for (var i = 0; i < infos.length; i=i+2)
{
%>
	<tr>
		<td>
		<p><strong><%=infos[i].postCode%></strong></p>
		<p align="center">
			<%=infos[i].address%><br />
			<strong><%=infos[i].company%></strong>（收）
		</p>
		</td>
		<td>
		<p><strong><%=infos[i + 1].postCode%></strong></p>
		<p align="center">
			<%=infos[i + 1].address%><br />
			<strong><%=infos[i + 1].company%></strong> （收）
		</p>
</td>
	</tr>

<%
}
%>
</table><%
%>

</body>
</html>

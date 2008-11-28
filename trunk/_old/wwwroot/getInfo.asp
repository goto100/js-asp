<%@LANGUAGE="JAVASCRIPT" CODEPAGE="65001"%>
<%
function write(str) {
	Response.Write(str);
}

var infos = []

var xmlHttp = new ActiveXObject("Microsoft.XMLHttp");

for (var i = 0; i < 1; i++)
{
	var stra = "pagenum=" + (i + 1) + "&kind=1";
	xmlHttp.open("POST", "http://www.cn-lace.com/comcatalog/catalog_list.jsp?menu=6&kind=1&kindid=001007", false);
	xmlHttp.setRequestHeader("Content-Length", stra.length);
	xmlHttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
	xmlHttp.send(stra);

	var links = xmlHttp.responseText.match(/catalog_detail\.jsp\?menu\=6\&kind\=1\&kindid=001007\&id\=(.+)\&cc\=/ig);
	for (var j = 0; j < links.length; j=j+2)
	{
		var info = {};
		xmlHttp.open("GET", "http://www.cn-lace.com/comcatalog/" + links[j], false);
		xmlHttp.send(null);
		xmlHttp.responseText.match(/邮政编码：\<\/div\>\<\/TD\>\s+\<TD bgcolor\=\"\#EFFFE0\"\>\<font color\=\"\#666666\"\>(.*)\<\/font\>/ig)[0];
		info.postCode = RegExp.$1;
		xmlHttp.responseText.match(/联 系 人：\<\/div\>\<\/TD\>\s+\<TD bgcolor\=\"\#EFFFE0\"\>\<font color\=\"\#666666\"\>(.+)\<\/font\>/ig)[0];
		info.name = RegExp.$1;
		xmlHttp.responseText.match(/办公地址：\<\/div\>\<\/TD\>\s+\<TD bgcolor\=\"\#FFFFFF\"\>\<font color\=\"\#666666\"\>(.+)\<\/font\>/ig)[0];
		info.address = RegExp.$1;
		xmlHttp.responseText.match(/公司名称：\<\/div\>\<\/TD\>\s+\<TD width\=\"389\" bgcolor\=\"\#ffffff\"\>\<span class\=\"info\"\>(.+)\</ig)[0];
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
		<p>
			<%=infos[i].address%><br />
			<%=infos[i].company%><br />
			<strong><%=infos[i].name%></strong> （收）
		</p>
		</td>
		<td>
		<p><strong><%=infos[i + 1].postCode%></strong></p>
		<p>
			<%=infos[i + 1].address%><br />
			<%=infos[i + 1].company%><br />
			<strong><%=infos[i + 1].name%></strong> （收）
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

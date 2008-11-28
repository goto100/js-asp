<%@LANGUAGE="JAVASCRIPT" CODEPAGE="936"%>
<script language="VBScript" runat="server">
function vbsFun(n):vbsFun=chr(n):end function
</script>
<%
Session.Timeout = 900;
Server.ScriptTimeout = 900;
Response.Charset = "gb2312";
Session.CodePage = 936;
Response.ContentType = "text/html";
function write(str) {
	Response.Write(str);
}
function utf2gb(bin) {
	var xmldom = new ActiveXObject("Microsoft.XMLDOM")
	var byteObj= xmldom.createElement("byteObj")
	byteObj.dataType = 'bin.hex'
	byteObj.nodeTypedValue = bin;
	var gObject={};
	
	return (byteObj.text).toUpperCase().replace(/.{2}/g,"@$&").replace(/@([^0-7].)@(.{2})/g,function(a,b,c){
			if(!gObject[b+c])
			gObject[b+c]=vbsFun(eval("0x"+b+c));
			return gObject[b+c];
	}).replace(/@(..)/g,function(d,e){
			if(!gObject[e])
			gObject[e]=vbsFun(eval("0x"+e));
			return gObject[e];
	})
}

var infos = []

var xmlHttp = new ActiveXObject("Microsoft.XMLHttp");
for (var i = 0; i < 14; i++)
{
	xmlHttp.open("GET", "http://www.gift12345.com/yp.asp?ypxxone_id=53&page=" + (i + 1), false);
	//xmlHttp.setRequestHeader("Content-Length", stra.length);
	//xmlHttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
	xmlHttp.setRequestHeader("Charset","gb2312");
	xmlHttp.send(null);
	var text = utf2gb(xmlHttp.responseBody);
	var links = text.match(/：\<a href\=http\:\/\/(.+?)\.gift12345\.com target\=\"\_blank\"\>/ig);
	for (var j = 0; j < links.length; j++)
	{
		var info = {};
		xmlHttp.open("GET", links[j].slice(9, links[j].length - 17) + "/usercontact.asp", false);
		try
		{
			xmlHttp.send(null);
			var text = utf2gb(xmlHttp.responseBody);
	
			//text.match(/邮　编：\<\/strong\>\<\/td\>\s+\<td\> \<font color\=\#000000\>(.*)\<\/font\>/ig);
			//info.postCode = RegExp.$1;
			text.match(/联系人：(.*?)\<\/td\>/ig);
			info.name = RegExp.$1;
			text.match(/\<td\>(.+?)\<\/td\>\s+\<td\>\<span class\=\"style2\"\>\&nbsp\;\&nbsp\;邮/ig);
			info.address = RegExp.$1;
			text.match(/称：\<\/span\>\<\/td\>\s+\<td width\=\"51\%\"\>(.+?)\<\/td\>/ig);
			info.company = RegExp.$1;
	
			infos.push(info);
		}
		catch(e)
		{
		}

		xmlHttp.abort();
	}
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GB2312" />
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

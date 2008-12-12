<!--#include file="../dao/UserDao.asp" -->
<script language="javascript" runat="server">
function UserListAction() {}
UserListAction.prototype = new ListAction();

UserListAction.prototype.action = function() {
	form();
	if (this.input["file"]) for(var i = 0; i < this.input["file"].length; i++) {
		writeln(this.input["file"][i].path)
		writeln(this.input["file"][i].name)
		writeln(this.input["file"][i].contentType)
		writeln(this.input["file"][i].size)
		writeln(this.input["text"])
		writeln(this.input["text2"])
		;;; test.start();
		this.input["file"][i].save(Server.MapPath("/js-asp/img/" + this.input["file"][i].name))
		;;; test.end("Save file: ");
	}
}


function AddUserAction() {};
AddUserAction.prototype = new FormAction();
AddUserAction.prototype.action = function() {
	write("add");
}

function EditUserAction() {};
EditUserAction.prototype = new FormAction();
EditUserAction.prototype.action = function() {
	write("edit");
}
</script>
<%
function form() {
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>无标题文档</title>
<style type="text/css">
pre {
	font-size: 9pt;
	border: 1px dashed #999;
}
</style>
<script type="text/javascript" src="base2-dom-fp.js"></script>
<script type="text/javascript">
eval(base2.namespace);
eval(base2.JavaScript.namespace);
JavaScript.bind(window);
DOM.bind(document);
DOM.EventTarget(window);

function FileTransferProgress(transferred, size, startTime) {
	this.startTime = startTime || Date.now();
	this.transferred = transferred || 0;
	this.size = size || 0;
	this.remain = this.size - this.transferred;
	this.percent = this.transferred * 100 / this.size;
	this.time = {};
	this.time.used = Date.now() - startTime;
	this.speed = this.transferred / this.time.used;
	this.time.remain = this.remain / this.speed;
}

var startTime = Date.now();
function DisplayProgressBar() {
	var interval = 500;
	var div = document.getElementById("progress");
	var filePath = "/js-asp/img/upload.xml";
    var request = new XMLHttpRequest();
	request.open("GET", filePath, false);
	request.setRequestHeader("No-Cache", "1");
	request.setRequestHeader("Pragma", "no-cache");
	request.setRequestHeader("Cache-Control", "no-cache");
	request.setRequestHeader("Expire", "0");
	request.setRequestHeader("Last-Modified", "Wed, 1 Jan 1997 00:00:00 GMT");
	request.setRequestHeader("If-Modified-Since", "-1");
	request.send(null);
	if (request.status != 200) setTimeout(DisplayProgressBar, interval);
	var xml = request.responseXML;
	var read = xml.documentElement.getAttribute("read");
	var total = xml.documentElement.getAttribute("total");
	var upload = new FileTransferProgress(parseInt(read), parseInt(total), startTime);
	div.innerHTML = "<ul><li>" + upload.transferred + "/" + upload.size + "</li>"
		+ "<li>Remain: " + Math.round(upload.remain / 1000) + "KB</li>"
		+ "<li>Speed: " + Math.floor(upload.speed) + "KB/s</li>"
		+ "<li>Time Used: " + Math.round(upload.time.used / 1000) + "s</li>"
		+ "<li>Time Remain: " + Math.round(upload.time.remain / 1000) + "s</li></ul>"
		+ "<div style=\"height: 10px; background-color: #000; width: " + upload.percent + "%\"\>  \<\/div\>";
	setTimeout(DisplayProgressBar, interval);
}


document.addEventListener("DOMContentLoaded", function() {
	var form = document.getElementById("form");
	form.onsubmit = function() {
		var div = document.createElement("div");
		div.setAttribute("id", "progress");
		document.documentElement.appendChild(div);
		DisplayProgressBar();
	}
}, false);
</script>
</head>

<body>
<form id="form" method="post" action="index.asp" enctype="multipart/form-data">
	<input name="file" type="file" />
	<input name="file" type="file" />
	<input name="file" type="file" />
	<input name="text" type="text" />
	<input name="text2" type="text" />
	<input name="submit" type="submit" />
	<input type="hidden" name="__method__" value="delete" />
</form>
</body>
</html>
<%
}
%>

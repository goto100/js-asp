<!--#include file="../dao/UserDao.asp" -->
<script language="javascript" runat="server">
function UserListAction() {}
UserListAction.prototype = new ListAction();
var a = new ListAction();

UserListAction.prototype.action = function() {
	var dao = site.getUserDao();

	var users = dao.list(this.getPageSize(10), this.getCurrentPage());
	users.forEach(function(user) {
		writeln(user.username);
	});

	form();
	if (this.input["file"]) for(var i = 0; i < this.input["file"].length; i++) {
		writeln(this.input["file"][i].name)
		writeln(this.input["file"][i].contentType)
		writeln(this.input["file"][i].size)
		this.input["file"][i].save(Server.MapPath("/js-asp/img/" + this.input["file"][i].name))
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
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="base2-dom-fp.js"></script>
<script type="text/javascript">
base2.JavaScript.bind(window);
base2.DOM.bind(document);
base2.DOM.EventTarget(window);


function DisplayProgressBar() {
	var div = document.getElementById("progress");
	var xmlPath = "/js-asp/img/upload.xml";
    var xmlHttp = new XMLHttpRequest();
	xmlHttp.open("GET", xmlPath, false);
	xmlHttp.send(null);
	var xml = xmlHttp.responseXML;

	var read = xml.documentElement.getAttribute("read");
	var total = xml.documentElement.getAttribute("total");
	div.innerHTML = read + "/" + total + "=" + Math.floor(read * 100 / total) + "%";

	setTimeout(DisplayProgressBar, 1000);
}


document.addEventListener("DOMContentLoaded", function() {
	var form = document.getElementById("form").elements["submit"].onclick = function() {
		var div = document.createElement("div");
		div.setAttribute("id", "progress");
		document.documentElement.appendChild(div);
		DisplayProgressBar();
	}
}, false);
</script>
<form id="form" method="post" action="index.asp" enctype="multipart/form-data">
	<input name="file" type="file" />
	<input name="file" type="file" />
	<input name="file" type="file" />
	<input name="file" type="file" />
	<input name="file" type="file" />
	<input name="file" type="file" />
	<input name="file" type="file" />
	<button name="delete" value="index.asp?1/1">删除</button>
	<input name="submit" type="submit" />
	<input type="hidden" name="__method__" value="delete" />
</form>
<%
}
%>

// Refresh security code picture
function refreshSecCodePic() {
	var img = document.getElementById("form_secCodePic");
	img.src = img.src + "#";
}

function getMsg(href, eles) {
	var xmlHttp = createXMLHttpRequest();

	if (eles) {
		xmlHttp.open("POST", href, false);
		xmlHttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
		var sendStr = "";
		for (var i = 0; i < eles.length; i++) {
			var value = eles[i].value.replace(/ /ig, "+");
			sendStr += eles[i].name + "=" + value + "&";
		}
		sendStr = sendStr.slice(0, -1);
		xmlHttp.send(sendStr);
	} else {
		xmlHttp.open("GET", href, false);
		xmlHttp.send(null);
	}

	var xmlDom = xmlHttp.responseXML;
	var msg = xmlDom.documentElement.getElementsByTagName("msg")[0];

	if (msg) {
		page.setMsg(getContent(msg));
		return false;
	}
}

function getFormEles(form) {
	var formEles = [];
	for (var i = 0; i < form.elements.length; i++) {
		if (form.elements[i].name) {
			formEles.push({"name":form.elements[i].name, "value":form.elements[i].value});
		}
	}
	return formEles;
}

function Register() {
	var eleForm = {};
	var eleEmail = {};

	// Load
	this.load = function() {
		if (document.getElementById("page-form") && document.getElementById("form")) {
			eleForm = document.getElementById("form").getElementsByTagName("form")[0];

			var xmlHttp = createXMLHttpRequest();
			xmlHttp.open("GET", "register.asp?output=xml", false);
			xmlHttp.send(null);

			var xmlDom = xmlHttp.responseXML;
			eleEmail = eleForm["form_" + xmlDom.documentElement.getElementsByTagName("form")[0].getElementsByTagName("email")[0].getAttribute("name")];
			eleEmail.onblur = checkEmail;
		}
	}

	//Check site ID
	function checkEmail() {
		if (eleEmail.value) {
			var xmlHttp = createXMLHttpRequest();

			xmlHttp.open("GET", "register.asp?checkemail&email=" + eleEmail.value, false);
			xmlHttp.send(null);

			if (xmlHttp.responseXML.documentElement.nodeName == "registerCheckEmail") {
				page.appendAlert(eleEmail.parentNode, getContent(xmlHttp.responseXML.documentElement.getElementsByTagName("result")[0]));
			} else {
				window.location = "register.asp";
			}
		}
	}
}

var register = new Register();
window.addEvent("load", register.load);

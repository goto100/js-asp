var isIE = false;
if (window.ActiveXObject) isIE = true;
// Return object's expando names
Object.prototype.getExpandoNames = function() {
	var values = [];
	var obj = new this.constructor();
	for (var i in this) {
		if (obj[i] != this[i]) {
			values.push(i);
		}
	}
	return values;
}

function outputErrorMsg(err) {
	alert(String(err.number & 0xFFFF)
		+ "\r\n" + err.name
		+ "\r\n" + err.description
		+ "\r\n" + err.message
		)
}
function addEvt(obj, strEv, objFun) { if (isIE) { return obj.attachEvent("on" + strEv, objFun); }
	else { obj.addEventListener(strEv, objFun, true); return true; } }
function removeEvt() { if (isIE) { return obj.detachEvent("on" + strEv, objFun); }
	else { obj.removeEventListener(strEv, objFun, true); return true; } }
function addEvent(obj, strEv, objFun) {
	addEvt(obj, strEv, objFun);
}
function removeEvent(obj, strEv, objFun) {
	removeEvt(obj, strEv, objFun);
}
window.addEvent = function (strEv, objFun) {
	addEvt(window, strEv, objFun);
}
document.addEvent = function (strEv, objFun) {
	addEvt(document, strEv, objFun);
}
window.removeEvent = function(strEv, objFun) {
	removeEvt(window, strEv, objFun);
}
document.removeEvent = function(strEv, objFun) {
	removeEvt(document, strEv, objFun);
}

function createXMLHttpRequest() {
	if (window.XMLHttpRequest) { // Mozilla
		try {
			return new XMLHttpRequest();
		} catch(e) {
			outputErrorMsg(e);
		}
	} else if (window.ActiveXObject) { // IE
		try {
			return new ActiveXObject("Microsoft.XMLHttp");
		} catch(e) {
			outputErrorMsg(e);
		}
	} else {
		outputErrorMsg("Create XMLHttpRequest object error.")
	}
}

function transform(strType, obj) {
	switch (strType) {
		case "string": return obj.toString();
		case "boolean": 
			if (obj == "true") return true;
			else if (obj == "false") return false;
			else return Boolean(obj);
		case "number": return parseInt(obj);
	}
}

function XMLDom(bAysnc) {
	////////// Attributes //////////////////////////////
	// Private //////////
	var dom = XMLDom.create(bAysnc);

	// Class Element
	function Element(str) {
		this.dom = dom.createElement(str);

		// Add a attribute
		this.addAttribute = function(strName, strValue) {
			this.dom.setAttribute(strName, strValue.toString());
		}

		// Add a child element
		this.addChild = function(str, objAttributes, strValue) {
			var element = new Element(str);
			this.dom.appendChild(element.dom);

			if (objAttributes) {
				var e = objAttributes.getExpandoNames();
				for (var i = 0; i < e.length; i++) {
					element.addAttribute(e[i], objAttributes[e[i]]);
				}
			}

			if (strValue) {
				element.setContent(strValue);
			}

			return element;
		}

		// Set content
		this.setContent = function(obj) {
			this.dom.text = obj.toString();
		}
	}

	// Public //////////
	this.documentElement = dom.documentElement;

	////////// Methods //////////////////////////////
	// Private //////////

	// Public //////////

	// Set root element
	this.setRoot = function(str) {
		var element = new Element(str);
		dom.documentElement = element.dom;

		this.documentElement = dom.documentElement;
		return element;
	}

	// Transform xml with xsl file
	this.transformNode = function(obj) {
		return dom.transformNode(obj);
	}

	// Get dom
	this.getDom = function() {
		return dom;
	}
}

XMLDom.create = function() {
	if (document.implementation.createDocument) { // Mozilla
		try {
			return document.implementation.createDocument("", "", null);
		} catch(e) {}
	} else if (window.ActiveXObject) { // IE
		try {
			return new ActiveXObject("Microsoft.XMLDom");
		} catch(e) {}
	} else {
		alert("Create XMLDom object error.")
	}
}

function setContent(obj, str) {
	if (isIE) {
		obj.innerText = str;
	} else {
		obj.textContent = str;
	}
}

function getContent(obj) {
	if (isIE) {
		if (!obj.innerText) return obj.text
		return obj.innerText;
	} else {
		return obj.textContent;
	}
}

function Page() {
	// Get searchs
	this.getSearchs = function() {
		var searchs = location.search.substring(1).split("&");
		var search = {};
		for (var i = 0; i < searchs.length; i++) {
			search[searchs[i].substring(0, searchs[i].indexOf("="))] = searchs[i].substring(searchs[i].indexOf("=") + 1);
		}
		return search;
	}

	// Append alert
	this.appendAlert = function(objNode, strAlert) {
		var eleAlert = document.createElement("p");
		eleAlert.className = "alert";
		setContent(eleAlert, strAlert);

		var tmpEles = objNode.getElementsByTagName("P");
		if (tmpEles.length > 0) {
			for (var i = 0; i < tmpEles.length; i++) {
				if (tmpEles[i].className == "alert") {
					objNode.replaceChild(eleAlert, tmpEles[i]);
					break;
				} else {
					objNode.appendChild(eleAlert);
				}
			}
		} else {
			objNode.appendChild(eleAlert);
		}
	}

	// Remove alert
	this.removeAlert = function(objNode) {
		var tmpEles = objNode.getElementsByTagName("P");
		for (var i = 0; i < tmpEles.length; i++) {
			if (tmpEles[i].className == "alert") {
				objNode.removeChild(tmpEles[i]);
			}
		}
	}

	// Set message
	this.setMsg = function(msg) {
		var eleMsg = document.getElementById("msg");
		if (!eleMsg) {
			var eleContent = document.getElementById("Content");
			var tMsg = document.createElement("div");
			tMsg.id = "msg";
			setContent(tMsg, msg);
			eleContent.insertBefore(tMsg, eleContent.firstChild);
		} else setContent(eleMsg, msg);
	}
}
var page = new Page();
var search = page.getSearchs();
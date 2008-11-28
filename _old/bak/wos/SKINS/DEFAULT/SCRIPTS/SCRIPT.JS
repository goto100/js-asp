var isIE = false;
if (document.width == undefined) isIE = true;

window.addEvent = function (strEv, objFun) {
	if (isIE) {
		return window.attachEvent("on" + strEv, objFun);
	} else {
		window.addEventListener(strEv, objFun, true);
		return true;
	}
}
document.addEvent = function (strEv, objFun) {
	if (isIE) {
		return document.attachEvent("on" + strEv, objFun);
	} else {
		document.addEventListener(strEv, objFun, true);
		return true;
	}
}
window.removeEvent = function(strEv, objFun) {
	if (isIE) {
		return window.detachEvent("on" + strEv, objFun);
	} else  {
		window.removeEventListener(strEv, objFun, true);
		return true;
	}
}
document.removeEvent = function(strEv, objFun) {
	if (isIE) {
		return document.detachEvent("on" + strEv, objFun);
	} else  {
		document.removeEventListener(strEv, objFun, true);
		return true;
	}
}

function Page() {
	this.outputMsg = function(strContent) {
		if (document.getElementById("msg")) {
			var msg = document.getElementById("msg");
		} else {
			var msg = document.createElement("p");
			msg.id = "msg";
		}
		
		isIE? msg.innerText = strContent : msg.textContent = strContent;
		document.getElementById("innerMain").insertBefore(msg, document.getElementById("innerMain").firstChild);
	}
	this.popWin = function() {
		this.title;
		this.content;
		this.width;
		this.height;
		this.canClose = true;
		this.elements = [];
		this.addElement = function(objElement) {
			this.elements.push(objElement);
		}
		this.run = function() {
			var mask = document.createElement("div");
			mask.id = "mask";

			this.win = document.createElement("div");
			this.win.id = "popWin";
			var title = document.createElement("h2");
			isIE? title.innerText = this.title : title.textContent = this.title;

			if (this.canClose) {
				var closeLink = document.createElement("a");
				closeLink.setAttribute("href", "javascript:Page.closeWin();");

				isIE? closeLink.innerText = "Close" : closeLink.textContent = "Close";
				title.appendChild(closeLink);
			}

			var content = document.createElement("div");
			content.className = "content";
			if (this.content) isIE? content.innerText = this.content : content.textContent = this.content;
			if (this.elements) {
				for (var i = 0; i < this.elements.length; i++) {
					content.appendChild(this.elements[i]);
				}
			}

			this.win.appendChild(title);
			this.win.appendChild(content);
			mask.appendChild(this.win);
			this.win.style.position = "absolute";
			this.win.style.width = this.width + "px";
			this.win.style.height = this.height + "px";
			document.body.appendChild(mask);

			Page.centerWin();

			window.addEvent("resize", Page.centerWin);
			//window.addEvent("scroll", Page.centerWin);
			window.onscroll = Page.centerWin;
		}
	}
}
Page.closeWin = function() {
	var mask = document.getElementById("mask");
	document.body.removeChild(mask);
	window.removeEvent("resize", Page.centerWin);
	window.onscroll = null;
}
Page.centerWin = function () {
	this.getViewportHeight = function () {
		if (window.innerHeight!=window.undefined) return window.innerHeight;
		if (document.compatMode=='CSS1Compat') return document.documentElement.clientHeight;
		if (document.body) return document.body.clientHeight; 
		return window.undefined; 
	}
	this.getViewportWidth = function () {
		if (window.innerWidth!=window.undefined) return window.innerWidth; 
		if (document.body) return document.body.clientWidth;
		return window.undefined; 
	}

	var mask = document.getElementById("mask");
	var win = document.getElementById("popWin");

	var width = win.offsetWidth;
	var height = win.offsetHeight;

	var fullHeight = this.getViewportHeight();
	var fullWidth = this.getViewportWidth();
	
	var theBody = document.documentElement;
	
	var scTop = parseInt(theBody.scrollTop,10);
	var scLeft = parseInt(theBody.scrollLeft,10);

	mask.style.height = fullHeight + "px";
	mask.style.width = fullWidth + "px";
	mask.style.top = scTop + "px";
	mask.style.left = scLeft + "px";
	
	win.style.top = ((fullHeight - height) / 2) + "px";
	win.style.left =  (scLeft + ((fullWidth - width) / 2)) + "px";

	//var fullWidth = isIE? window.document.body.clientWidth : window.innerWidth;
	//var fullHeight = isIE? document.documentElement.clientHeight : window.innerHeight;
	//win.style.left = (fullWidth - parseInt(win.style.width))/2 + "px";
	//win.style.top = (fullHeight - parseInt(win.style.height))/2 + "px";
}
var page = new Page();

function alertTest() {
	var at = new page.popWin();
	at.width = 300;
	at.height = 200;
	at.title = "title";
	at.content = "content";
	at.canClose = true;
	var btn = document.createElement("button");
	btn.id = "btn";
	isIE? btn.innerText = "btn" : btn.textContent = "btn";

	at.addElement(btn);
	at.run();
}

function createXMLHttpRequest() {
	if (isIE) {
		return new ActiveXObject("Microsoft.XMLHttp");
	} else {
		return new XMLHttpRequest();
	}
}

//window.addEvent("load", alertTest);
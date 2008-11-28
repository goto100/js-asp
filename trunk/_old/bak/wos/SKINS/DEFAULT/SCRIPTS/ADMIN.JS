function changeSkin() {
	var defaultSkin = document.getElementsByName("defaultSkin")[0];
	if(defaultSkin) {
		defaultSkin.onchange = function() {
			var skinCodeName = defaultSkin.item(this.selectedIndex).getAttribute("value");
			getSkin(skinCodeName);
		}
	}
}

function getSkin(skinCodeName) {
	var xmlHttp = createXMLHttpRequest();
	xmlHttp.onreadystatechange = function() {
		if (xmlHttp.readyState == 4) {
			var items = xmlHttp.responseXML.getElementsByTagName("lang");
	
			var defaultLang = document.getElementsByName("defaultLang")[0];
			defaultLang.length = 0;
			for (var i = 0; i < items.length; i++) {
				defaultLang.options[i] = new Option(isIE? items[i].text : items[i].textContent, isIE? items[i].text : items[i].textContent);
			}
	
			// Get styles
			var items = xmlHttp.responseXML.getElementsByTagName("style");
	
			var defaultStyle = document.getElementsByName("defaultStyle")[0];
			defaultStyle.length = 0;
			for (var i = 0; i < items.length; i++) {
				defaultStyle.options[i] = new Option(isIE? items[i].text : items[i].textContent, isIE? items[i].text : items[i].textContent);
			}
		}
	}

	xmlHttp.open("GET", "?getskin=" + skinCodeName, true);
	xmlHttp.send(null);
}

window.addEvent("load", changeSkin);

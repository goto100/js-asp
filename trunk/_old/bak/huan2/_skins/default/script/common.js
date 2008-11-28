function TreeView(element) {
	var lang = {
		open: "打开",
		close: "关闭"
	}

	this.execute = function() {
		if (element.constructor == String) element = document.getElementById(element);

		var eleLis = element.getElementsByTagName("li");
		for (var eleSwitch, eleUl, i = 0; i < eleLis.length; i++) {
			if (eleLis[i].getElementsByTagName("ul")[0]) { // Has child tree
				eleSwitch = document.createElement("span");
				eleSwitch.className = "switch";
				eleSwitch.textContent = lang.close;
				eleSwitch.title = lang.close;
				eleSwitch.onclick = function() {
					eleUl = this.parentNode.getElementsByTagName("ul")[0];
					if (this.parentNode.className == "closed") {
						this.textContent = lang.close;
						this.title = lang.close;
						this.parentNode.className = "";
						eleUl.style.display = "";
					} else {
						this.textContent = lang.open;
						this.title = lang.open;
						this.parentNode.className = "closed";
						eleUl.style.display = "none";
					}
				}
				eleLis[i].insertBefore(eleSwitch, eleLis[i].firstChild);
			} else eleLis[i].className = "leaf"; // Is a leaf
		}
	}
}
function load() {
	var docId = document.getElementsByTagName("body")[0].getAttribute("id");

	if (docId == "page-member-edit" || docId == "page-member-members") {
		var anchors = document.getElementsByTagName("a");
		for (var i = 0; i < anchors.length; i++) {
			if (anchors[i].href.indexOf("?delete&id=") != -1) {
				anchors[i].onclick = function() {
					if (confirm("确定要删除此用户么？")) return getMsg(this.href);
					else return false;
				}
			}
		}
	}

	if (docId == "page-member-members") {
		var form = document.getElementById("Content").getElementsByTagName("form")[0];
		if (form) {
			form.onsubmit = function () {
				return getMsg(this.action + "p=" + this.p.value);
			}
		}
	}
}
window.addEvent("load", load);

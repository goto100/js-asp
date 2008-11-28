function load() {
	var docId = document.getElementsByTagName("body")[0].getAttribute("id");

	if (docId == "page-category-edit" || docId == "page-category-categories") {
		var anchors = document.getElementsByTagName("a");
		for (var i = 0; i < anchors.length; i++) {
			if (anchors[i].href.indexOf("?delete&id=") != -1) {
				anchors[i].onclick = function() {
					if (confirm("确定要删除此分类么？")) return getMsg(this.href);
					else return false;
				}
			}
		}
	}
}
window.addEvent("load", load);

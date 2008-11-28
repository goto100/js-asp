<script language="javascript" runat="server">
function HuanSkin(id) {
	this.id = id;
	this.name = "";
	this.version = "";
	this.author = "";
	this.styles = [];
	this.skinsFolder = "";

	this.load = function() {
		var dom = new XMLDom;

		dom.load(Server.MapPath(this.skinsFolder + this.id + "/config.xml"));
		if (dom.parseError.errorCode) {
			delete dom;
			return false;
		}
		var fso = new ActiveXObject("Scripting.FileSystemObject");

		this.name = dom.documentElement.getElementsByTagName("name")[0].text;
		this.version = dom.documentElement.getElementsByTagName("version")[0].text;
		this.author = dom.documentElement.getElementsByTagName("author")[0].text;
		try {
			var folderStyles = fso.getFolder(Server.MapPath(this.skinsFolder + this.id + "/styles"));
		} catch (e) {
			return false;
		}
		var e = new Enumerator(folderStyles.subFolders);
		for (var folderStyle; !e.atEnd(); e.moveNext()) {
			folderStyle = e.item();
			dom.load(folderStyle.path + "/config.xml");
			this.styles.push({id: folderStyle.name,
				name: dom.documentElement.getElementsByTagName("name")[0].text,
				version: dom.documentElement.getElementsByTagName("version")[0].text,
				author: dom.documentElement.getElementsByTagName("author")[0].text});
		}

		return true;
	}
}
</script>
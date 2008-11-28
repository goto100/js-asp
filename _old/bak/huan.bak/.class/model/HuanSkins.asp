<script language="javascript" runat="server">
function HuanSkins() {
	List.call(this);

	this.skinsFolder = "";

	this.load = function() {
		var fso = new ActiveXObject("Scripting.FileSystemObject");
		var domSkin = new XMLDom;

		var folderSkins = fso.getFolder(Server.MapPath(this.skinsFolder));
		var e = new Enumerator(folderSkins.subFolders);
		for (var folderSkin; !e.atEnd(); e.moveNext()) {
			folderSkin = e.item();
			domSkin.load(folderSkin.files("config.xml").path);
			if (!domSkin.documentElement) throw new Error(0, "Load skin file ERROR.");

			var skin = {
				id: folderSkin.name
			}
			for (var i = 0, names = ["name", "version", "author"]; i < names.length; i++) {
				skin[names[i]] = domSkin.documentElement.getElementsByTagName(names[i])[0];
				if (skin[names[i]]) skin[names[i]] = skin[names[i]].text;
			}
			this.push(skin);
		}
		delete e;

		delete fso;
		delete domSkin;
		return true;
	}
}
</script>
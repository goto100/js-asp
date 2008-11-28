<script language="javascript" runat="server">
function HuanSettingCache(system) {
	CacheBase.call(this, system, "Settings");

	this.setting = new HuanSetting(system);

	this.ongetcache = function() {
		var cache = this.setting.getVbArr();
		this.save(cache);
		delete cache;
	}

	this.onload = function() {
		this.setting.fill(this.cache);
	}

	this.build = function(path) {
		this.reload();
		var view = new View("setting");
		view.contentType = View.XML;
		view.content.addChild("siteName", system.setting.siteName);
		view.content.addChild("siteURL", system.setting.siteURL);
		view.content.addChild("defaultLanguage", system.setting.defaultLanguage);
		view.content.addChild("defaultSkin", system.setting.defaultSkin);
		view.content.addChild("defaultStyle", system.setting.defaultStyle);
		view.build(path);
	}
}
</script>
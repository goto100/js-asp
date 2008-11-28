<script language="javascript" runat="server">
function HuanSettingCache(system) {
	CacheBase.apply(this, ["Settings"]);

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
		var page = new Page("setting");
		page.contentType = "xml";
		page.content.addChild("siteName", system.setting.siteName);
		page.content.addChild("siteURL", system.setting.siteURL);
		page.content.addChild("defaultLanguage", system.setting.defaultLanguage);
		page.content.addChild("defaultSkin", system.setting.defaultSkin);
		page.content.addChild("defaultStyle", system.setting.defaultStyle);
		page.build(path);
	}
}
</script>
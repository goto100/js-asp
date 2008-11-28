<!--#include file="HuanSettingCache.asp" -->
<!--#include file="HuanUserGroupsCache.asp" -->
<!--#include file="HuanCategoryCache.asp" -->
<script language="javascript" runat="server">
function HuanCache(system) {
	this.loaded = false;
	this.setting = new HuanSettingCache(system);
	this.userGroups = new HuanUserGroupsCache(system);

	// Load
	this.load = function() {
		this.setting.load();
		this.userGroups.load();

		this.loaded = true;
	}

	// Reload
	this.reload = function() {
		this.clean();
		this.load();
	}

	// Clean
	this.clean = function() {
		this.setting.clean();
		this.userGroups.clean();

		this.loaded = false;
	}

	// Build to file
	this.build = function(path) {
		this.setting.build(path + "setting.xml");
		this.userGroups.build(path + "userGroups.xml");
		var category = new HuanCategoryCache;
		category.build(path + "category.xml");
	}
}
</script>
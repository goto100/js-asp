<script language="javascript" runat="server">
function HuanUserGroupsCache(system) {
	CacheBase.call(this, system, "UserGroups");

	this.userGroups = new HuanUserGroups(system);

	this.ongetcache = function() {
		var cache = this.userGroups.getVbArr();
		this.save(cache);
		delete cache;
	}

	this.onload = function() {
		this.userGroups.clear();
		this.userGroups.fill(this.cache);
	}

	this.build = function(path) {
		this.reload();
		var view = new View("userGroups");
		view.contentType = View.XML;
		view.build(path);
	}
}
</script>
<script language="javascript" runat="server">
function HuanUserGroupsCache(system) {
	CacheBase.apply(this, ["UserGroups"]);

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
		var page = new Page("userGroups");
		page.contentType = "xml";
		page.build(path);
	}
}
</script>
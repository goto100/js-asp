<script language="javascript" runat="server">
function CacheBase(system, cacheName) {
	this.loaded = false;
	this.cacheName = cacheName + "Cache";
	this.ongetcache = null;
	this.onload = null;

	this.cache = system.getApplication(this.cacheName);

	this.save = function(value) {
		system.setApplication(this.cacheName, value);
		this.cache = system.getApplication(this.cacheName);
	}

	this.clean = function() {
		system.removeApplication(this.cacheName);
		delete this.cache;
	}

	this.reload = function() {
		this.clean();
		this.load();
	}

	this.load = function() {
		if (this.cache == null && this.ongetcache) this.ongetcache();
		if (this.cache != null && this.onload) this.onload();
		this.loaded = true;
	}
}
</script>
<script language="javascript" runat="server">
function System(name) {
	this.name = name || "";
	this.version = "";
	this.author = "";

	this.getSession = function(name) {
		return Session(this.name + ":" + name);
	}

	this.setSession = function(name, value) {
		Session(this.name + ":" + name) = value;
	}

	this.removeSession = function(name) {
		Session.Contents.Remove(this.name + ":" + name);
	}

	this.clearSession = function() {
		Session.Contents.RemoveAll();
	}

	this.getApplication = function(name) {
		return Application(this.name + ":" + name);
	}

	this.setApplication = function(name, value) {
		Application.Lock();
		Application(this.name + ":" + name) = value;
		Application.UnLock();
	}

	this.removeApplication = function(name) {
		Application.Contents.Remove(this.name + ":" + name);
	}

	this.clearApplication = function() {
		Application.Contents.RemoveAll();
	}

	this.encode = function(str) {
		return hex_sha1(str);
	}
}
</script>
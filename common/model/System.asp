<script language="javascript" runat="server">
function System(name) {
	this.name = name || "";
	this.version = "";
	this.author = "";
}
System.prototype.getSession = function(name) {
	return Session(this.name + ":" + name);
}

System.prototype.setSession = function(name, value) {
	Session(this.name + ":" + name) = value;
}

System.prototype.removeSession = function(name) {
	Session.Contents.Remove(this.name + ":" + name);
}

System.prototype.clearSession = function() {
	Session.Contents.RemoveAll();
}

System.prototype.getApplication = function(name) {
	return Application(this.name + ":" + name);
}

System.prototype.setApplication = function(name, value) {
	Application.Lock();
	Application(this.name + ":" + name) = value;
	Application.UnLock();
}

System.prototype.removeApplication = function(name) {
	Application.Contents.Remove(this.name + ":" + name);
}

System.prototype.clearApplication = function() {
	Application.Contents.RemoveAll();
}

System.prototype.encode = function(str) {
	return hex_sha1(str);
}
</script>
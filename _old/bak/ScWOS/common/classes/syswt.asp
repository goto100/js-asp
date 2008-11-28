<!-- #include file = "dbconn.asp" -->
<!-- #include file = "dbform.asp" -->
<%
function SysWT() {
	this.dbPath = "";
	this.conn = {};
	this.cache = {};
	this.setting = {};

	this.load = function() {
		this.conn = new DBConn(this.dbPath);
		this.conn.open();
		this.cache = new Cache(this.conn);
		this.cache.load();
		this.setting = this.cache.setting;
		this.user = new User(this.conn);
	}

	this.getMember = function(id) {
		var member = new User();
		var tmpA = this.conn.query("SELECT TOP 1 id, nickname, groupId, firstName, lastName, gender, secQuestion, secAnswer"
			+ " FROM [Members]"
			+ " WHERE id = " + id);
		if (tmpA) {
			member.fill(tmpA);
			return member;
		}
	}

	this.getMembers = function(size, current) {
		var members = this.conn.query("SELECT m.id AS id, m.email, m.nickname, m.gender, g.id AS groupId, g.name AS groupName"
			+ " FROM [Members] AS m, [UserGroups] AS g"
			+ " WHERE m.groupId = g.id", size, current);
		if (members) {
			members.total = this.conn.recordCount;
			return members;
		}
	}

	this.deleteMember = function(id) {
		if (this.conn.del("Members", "id = " + id)) return true;
	}

	function Cache(conn) {
		this.loaded = false;

		// Class Setting
		function Setting(conn) {
			this.cacheName = getSiteName("SettingsCache");
			this.loaded = false;
	
			this.load = function() {
				var tmpA = sys.conn.query("SELECT * FROM [Settings]", null, null, true);
				if(tmpA != null){
					Cache.save(this.cacheName, tmpA);
					this.fill();
				}
				delete tmpA;
			}
	
			this.fill = function() {
				var quaryArr = Application(this.cacheName);
				for (var i = 0; i <= quaryArr.ubound(2); i++) {
					switch (quaryArr.getItem(1, i)) {
						case 0 : var value = quaryArr.getItem(2, i); break;
						case 1 : var value = quaryArr.getItem(3, i); break;
						case 2 : var value = quaryArr.getItem(4, i); break;
					}
					this[quaryArr.getItem(0, i)] = value;
				}
				this.loaded = true;
			}
	
			this.remove = function() {
				Cache.remove(this.cacheName);
			}
		}
	
		// Load cache
		this.load = function() {
			this.setting = new Setting(conn);
	
			if (!Application(this.setting.cacheName)) this.setting.load();
			else this.setting.fill();
		}
	
		// Remove all cache
		this.removeAll = function() {
			Application.Contents.RemoveAll();
		}
	}

	// Save to application
	Cache.save = function(name, value) {
		Application.Lock();
		Application(name) = value;
		Application.Unlock();
	}
	
	// Remove from cache
	Cache.remove = function(name) {
		Application.Contents.Remove(name);
	}

}
%>

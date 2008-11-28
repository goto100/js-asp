<!--#include file="../user/HuanUserRight.asp" -->
<script language="javascript" runat="server">
function HuanUser(system) {
	this.id = 0;
	this.userId = "";
	this.nickname = "";
	this.password = "";
	this.group = null;
	this.secQuestion = null;
	this.secAnswer = null;
	this.right = null;
	this.lastIP = null;
	this.loggedIn = false;
	this.currentUser = true;
	this.os = null;
	this.browser = null;
	this.visitTime = null;
	this.lastVisitTime = null;
	this.onlineTime = null;
	this.referer = null;
	this.target = null;

	this.outlineTime = null;

	this.visit = function(id, password) {
		if (id) this.login(id, password);
		this.outlineTime = new Date(system.now);
		this.outlineTime.setMinutes(this.outlineTime.getMinutes() - system.setting.recordUsersTimeOut);

		var sql = "lastVisitTime < #" + system.db.checkDate(this.outlineTime) + "# OR lastVisitTime IS NULL";
		if (this.loggedIn) sql += " OR id = " + Session.SessionID; // Clear not logged in online record when user logged in
		system.db.del(system.table.users, sql);

		if (this.loggedIn && !this.visitTime) system.removeSession("lastVisitTime");

		if (!this.loggedIn) this.id = Session.SessionID;
		this.lastVisitTime = new Date(system.getSession("lastVisitTime"));
		system.setSession("lastVisitTime", system.now.getVarDate());
		if (isNaN(this.lastVisitTime)) { // First time visit
			this.visitTime = system.now;
			if (this.loggedIn) system.db.update(system.table.members, {lastIP: this.ip,
				visitTime: this.visitTime,
				lastVisitTime: system.now}, "id = " + this.id);
			else system.db.insert(system.table.users, {id: this.id,
				ip: this.ip,
				visitTime: this.visitTime,
				lastVisitTime: system.now});
			// Record visitor
			if (system.setting.recordVisitor) system.db.insert(system.table.visitors, {ip: this.ip,
				os: this.os,
				browser: this.browser,
				time: this.visitTime,
				referer: this.referer,
				target: this.target});
		} else {
			if (this.loggedIn) { // Visited in a short time, update last visit time
				this.onlineTime += parseInt((system.now - this.lastVisitTime) / 1000);
				system.db.update(system.table.members, {lastVisitTime: system.now,
					onlineTime: this.onlineTime}, "id = " + this.id);
			} else system.db.update(system.table.users, {lastVisitTime: system.now}, "id = " + this.id);
		}
	}

	this.login = function(userId, password) {
		if (this.loggedIn) return;
		var sql = "SELECT m.id, m.userId, m.password, m.nickname, m.right, m.onlineTime, m.visitTime, g.id AS groupId, g.right AS groupRight"
			+ " FROM " + system.table.members + " AS m, " + system.table.userGroups + " AS g"
			+ " WHERE m.groupId = g.id";
		sql += " AND m." + (isNaN(userId)? "userId = '" + userId + "'" : "id = " + userId);
		var record = system.db.query(sql, 1);
		if (!record) throw new Error(0);
		if (password != record.password) throw new Error(1);
		this.fill(record);

		this.loggedIn = true;
	}

	this.logout = function() {
		if (!this.loggedIn) return;
		this.loggedIn = false;
		system.db.update(system.table.members, {visitTime: null}, "id = " + this.id);
		system.removeSession("lastVisitTime");
		this.id = 0;
		this.load();
	}

	this.load = function() {
		if (!this.id) return;

		var record = system.db.query("SELECT id, userId, nickname, secQuestion, secAnswer, lastIp, lastVisitTime, groupId"
			+ " FROM " + system.table.members
			+ " WHERE id = " + this.id, 1);
		if (!record) return;
		system.setSession("userLoggedIn", true);

		this.fill(record);
		return this.id;
	}

	this.loadId = function() {
		var record = system.db.query("SELECT id FROM "+ system.table.members + " WHERE userId = '" + this.userId + "'", 1);
		if (record) this.id = record.id;
		return this.id;
	}

	this.fill = function(record) {
		this.id = record.id;
		this.userId = record.userId;
		this.nickname = record.nickname;
		this.password = record.password;
		this.group = system.getUserGroup(record.groupId);
		this.secQuestion = record.secQuestion;
		this.secAnswer = record.secAnswer;
		this.lastIP = record.lastIP;
		this.visitTime = record.visitTime;
		this.lastVisitTime = record.lastVisitTime;
		this.onlineTime = record.onlineTime;
		this.right = new HuanUserRight(record.right || this.group.right);
	}

	this.checkUserIdUsed = function(userId) {
		return system.db.query("SELECT userId FROM " + system.table.members + " WHERE userId = '" + userId + "'", 1)? true : false;
	}

	this.save = function(value) {
		if (value.password) value.password = system.encode(value.password);
		if (!value.groupId) value.groupId = 2;
		if (value) this.fill(value);

		system.db.insert(system.table.members, {userId: this.userId,
			nickname: this.nickname,
			password: this.password,
			groupId: this.group.id,
			secQuestion: this.secQuestion,
			secAnswer: this.secAnswer,
			onlineTime: 0});
	}

	this.changePassword = function(password) {
		if (password) this.password = password;
		system.db.update(system.table.members, {password: this.password}, "id = " + this.id);
	}

	this.update = function(value) {
		if (value.password) value.password = system.encode(value.password);
		if (value) this.fill(value);

		var updateItem = {
			userId: this.userId,
			nickname: this.nickname,
			groupId: this.group.id,
			secQuestion: this.secQuestion,
			secAnswer: this.secAnswer
		}
		if (this.password) updateItem.password = this.password;

		system.db.update(system.table.members, updateItem, "id = " + this.id);
	}

	this.getRight = function(right) {
		if (!this.right) this.right = new HuanUserRight(this.group.right);

		return this.right.getRight(right);
	}

	this.getMessages = function() {
		return new HuanUserMessages(system);
	}

	this.getMessage = function(id) {
		var message = new HuanUserMessage(id);
		message.setSystemSource(system);
		return message;
	}

	this.del = function() {
		system.db.del(system.table.members, "id = " + this.id);
	}
}
</script>
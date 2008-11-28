<script language="javascript" runat="server">
function HuanUserMessage(system) {
	this.id = id || 0;
	this.reciver = null;
	this.sender = null;
	this.title = "";
	this.content = "";

	this.load = function() {
		var record = system.db.query("SELECT m.id, m.title, m.sendTime, m.content, [m.read] AS [read], m.sent, s.id AS senderId, s.nickname AS senderNickname, r.id AS reciverId, r.nickname AS reciverNickname"
			+ " FROM " + system.table.messages + " AS m, " + system.table.members + " AS s, " + system.table.members + " AS r"
			+ " WHERE m.reciverId = r.id AND m.senderId = s.id"
			+ " AND m.id = " + this.id, 1);
		if (!record) return;
		this.id = record.id;
		this.title = record.title;
		this.content = record.content;
		this.reciver = {
			id: record.reciverId,
			nickname: record.reciverNickname
			}
		this.sender = {
			id: record.senderId,
			nickname: record.senderNickname
		}
		this.sendTime = record.sendTime;
		this.sent = record.sent;
		return this.id;
	}

	this.send = function(value) {
		if (value) {
			this.title = value.title;
			this.content = value.content;
		}
		this.sendTime = system.now;
		if (!this.reciver.id) return false;
		system.db.insert(system.table.messages, {reciverId: this.reciver.id,
			senderId: system.user.id,
			title: this.title,
			content: this.content,
			sendTime: this.sendTime});
	}

	this.save = function() {
		if (!this.reciver.id) return false;
		system.db.insert(system.table.messages, {reciverId: this.reciver.id,
			senderId: system.user.id,
			title: this.title,
			content: this.content,
			sendTime: this.sendTime,
			sent: true});
	}

	this.del = function() {
		system.db.del(system.table.messages, "id = " + this.id);
	}
}
</script>
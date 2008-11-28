<script language="javascript" runat="server">
function HuanUserMessages(system) {
	List.call(this);

	this.sender = null;
	this.reciver = null;
	this.sent = null;

	this.load = function() {
		var sql = "SELECT m.id, m.title, m.sendTime, m.content, [m.read] AS [read], m.sent, s.id AS senderId, s.nickname AS senderNickName, r.id AS reciverId, r.nickname AS reciverNickName"
			+ " FROM " + system.db.MESSAGES + " AS m, " + system.db.USERS + " AS s, " + system.db.USERS + " AS r"
			+ " WHERE m.reciverId = r.id AND m.senderId = s.id"
		if (this.sender) sql += " AND m.senderId = " + this.sender.id;
		if (this.reciver) sql += " AND m.reciverId = " + this.reciver.id;
		if (this.sent) sql += " AND m.sent = TRUE"
		sql += this.getOrderSQL({senderId: "m.senderId",
			reciverId: "reciverId",
			title: "title",
			sendTime: "sendTime"});
		var records = system.db.query(sql, this.pageSize, this.currentPage);
		if (!records) return;
		this.setRecords(records);
		for (var record; !records.atEnd(); records.moveNext()) {
			record = records.item();
			record.reciver = {
				id: record.reciverId,
				nickname: record.reciverNickName
			}
			record.sender = {
				id: record.senderId,
				nickname: record.senderNickName
			}
			delete record.reciverId, record.reciverNickName, record.senderId, record.senderNickName;
			this.push(record);
		}
	}
}
</script>
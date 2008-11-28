<script language="javascript" runat="server">
function Dao() {
	this.db = null;
	this.tableName = "";
	this.Pojo = null;
}

Dao.prototype.list = function(pageSize, currentPage) {
	var pojos = [];
	var recs = this.db.query("SELECT * FROM " + this.db.prefix + "_" + this.tableName, pageSize, currentPage);
	if (recs) {
		var dao = this;
		recs.forEach(function(rec) {
			pojos.push(dao.toPojo(rec));
		});
	}
	return pojos;
}

Dao.prototype.update = function(pojos, id) {
	this.db.update(this.db.prefix + "_" + this.tableName, this.fromPojo(pojos), "id IN( " + id + ")");
}

Dao.prototype.save = function(pojos) {
	this.db.insert(this.db.prefix + "_" + this.tableName, this.fromPojo(pojos));
}

Dao.prototype.del = function(id) {
	this.db.del(this.db.prefix + "_" + this.tableName, "id IN (" + id + ")");
}
</script>
<script language="javascript" runat="server">
function Dao() {
	this.db = null;
	this.table = "";
	this.Pojo = null;
}

Dao.prototype.list = function(pageSize, currentPage) {
	var pojos = [];
	var recs = this.db.query("SELECT * FROM " + this.table, pageSize, currentPage);
	if (recs) {
		var dao = this;
		recs.forEach(function(record) {
			pojos.push(dao.toPojo(record));
		});
	}
	return pojos;
}

Dao.prototype.update = function(pojos, id) {
	this.db.update(this.table, this.fromPojo(pojos), "id IN( " + id + ")");
}

Dao.prototype.save = function(pojos) {
	this.db.insert(this.table, this.fromPojo(pojos));
}

Dao.prototype.del = function(id) {
	this.db.del(this.table, "id IN (" + id + ")");
}
</script>
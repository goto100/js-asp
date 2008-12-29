<!--#include file="../../dao/Dao.asp" -->
<!--#include file="../pojos/Category.asp" -->
<script language="javascript" runat="server">
function CategoryDao() {
	this.table = "Category";
}
CategoryDao.prototype = new Dao();

CategoryDao.prototype.get = function(id, withSubs) {
	if (!withSubs) { // Only one record
		var sql = "SELECT TOP 1 id, lFlag, rFlag";
		for (var i = 0; i < loadItems.length; i++) sql += ", " + loadItems[i];
		sql += " FROM [" + this.table + "] WHERE id = " + id;
		var record = this.db.query(sql, 1);
		if (!record) return 0;
		lFlag = record.rFlag;
		rFlag = record.lFlag;
		if (lFlag - rFlag == 1) this.isLeaf = true;
		this.fill(record);
		return id;
	}
	// Also get sub categories
	var sql = "SELECT id, parentId, lFlag, rFlag";
	for (var i = 0; i < loadItems.length; i++) sql += ", " + loadItems[i];
	sql += " FROM [" + this.table + "]";
	if (id) {
		var record = this.db.query("SELECT TOP 1 lFlag, rFlag FROM [" + this.table + "] WHERE id = " + id, 1);
		sql += " WHERE lFlag BETWEEN " + record.lFlag + " AND " + record.rFlag;
	}
	sql += " ORDER BY lFlag";

	var records = this.db.query(sql);
	if (!records) return false;

	for (var record; !records.atEnd(); records.moveNext()) {
		record = records.item();
		var category = dao.toPojo(record);
		this.addCategory(category);
	}
	return true;
}

CategoryDao.prototype.addCategory = function(category) {
	if (category.parent.id == 0) { // Root
		category.depth = 1;
		category.parent = this;
		this.appendNode(category);
	} else if (category.parent.id == lastCategory.id) { // Last node's node
		category.parent = lastCategory;
		category.depth = category.parent.depth + 1;
		lastCategory.appendNode(category);
	} else { // Last node's parent node's node
		var parent = lastCategory.parent;
		while (category.parent.id != parent.id) parent = parent.parent;
		category.parent = parent;
		category.depth = category.parent.depth + 1;
		parent.appendNode(category);
	}
	lastCategory = category;
}

CategoryDao.prototype.setParentCategory = function(id) {
	this.parent = {
		id: id
	}
}

CategoryDao.prototype.move = function(id, isDown) {
	if (isDown) {
		var bCategory = this.db.query("SELECT lFlag, rFlag FROM [" + this.table + "] WHERE id = " + id, 1);
		var aCategory = this.db.query("SELECT lFlag, rFlag FROM [" + this.table + "] WHERE lFlag = " + (bCategory.rFlag + 1), 1);
		if (!aCategory) return false;
	} else {
		var aCategory = this.db.query("SELECT lFlag, rFlag FROM [" + this.table + "] WHERE id = " + id, 1);
		var bCategory = this.db.query("SELECT lFlag, rFlag FROM [" + this.table + "] WHERE rFlag = " + (aCategory.lFlag - 1), 1);
		if (!bCategory) return false;
	}
	var subValue = aCategory.lFlag - bCategory.lFlag;
	var plusValue = aCategory.rFlag - bCategory.rFlag;
	this.db.beginTrans();
	this.db.update(this.table,
		"lFlag = - (lFlag + " + plusValue + "), rFlag = - (rFlag + " + plusValue + ")",
		"lFlag BETWEEN " + bCategory.lFlag + " AND " + bCategory.rFlag);
	this.db.update(this.table,
		"lFlag = lFlag - " + subValue + ", rFlag = rFlag - " + subValue,
		"lFlag BETWEEN " + aCategory.lFlag + " AND " + aCategory.rFlag);
	this.db.update(this.table,
		"lFlag = - lFlag, rFlag = - rFlag",
		"lFlag BETWEEN - " + (bCategory.lFlag + plusValue) + " AND - " + (bCategory.rFlag + plusValue));
	this.db.endTrans();
	return true;
}

CategoryDao.prototype.up = function(id) {
	return this.move(id);
}

CategoryDao.prototype.down = function(id) {
	return this.move(id, true);
}

CategoryDao.prototype.save = function(category) {
	if (!category.parent) {
		var maxFlag = this.db.query("SELECT MAX(rFlag) AS maxFlag FROM [" + this.table + "]", 1).get("maxFlag");
		var saveItem = {
			parentId: 0,
			depth: 0,
			lFlag: maxFlag + 1,
			rFlag: maxFlag + 2,
			name: category.name
		}
		this.db.insert(this.table, new Map(saveItem));
	} else {
		var pCate = this.db.query("SELECT depth, rFlag FROM [" + this.table + "] WHERE id = " + category.parent.id, 1);

		this.db.doTrans(function() {
			var rFlag = pCate.get("rFlag");
			var depth = pCate.get("depth");
			this.db.update(this.table, "rFlag = rFlag + 2", "rFlag >= " + rFlag);
			this.db.update(this.table, "lFlag = lFlag + 2", "lFlag >= " + rFlag);
			var saveItem = {
				parentId: category.parent.id,
				depth: depth + 1,
				lFlag: rFlag,
				rFlag: rFlag + 1,
				name: category.name
			}
			this.db.insert(this.table, new Map(saveItem));
		}, this);
	}
}

CategoryDao.prototype.list = function() {
	var pojos = [];
	var recs = this.db.query("SELECT * FROM " + this.table);
	if (recs) {
		var dao = this;
		recs.forEach(function(rec) {
			pojos.push(dao.toPojo(rec));
		});
	}
	return pojos;
}

CategoryDao.prototype.toPojo = function(record) {
	var category = new Category();
	category.id = record.id;
	category.parent = new Category(record.parentId)
}

CategoryDao.prototype.update = function(id, category) {
	if (category) this.fill(category);
	if (this.fillUpdateItem) this.fillUpdateItem(updateItem);
	this.db.update(this.table, updateItem, "id = " + id);
}

CategoryDao.prototype.del = function(id) {
	if (this.isLeaf) {
		this.db.beginTrans();
		this.db.update(this.table, "rFlag = rFlag - 2", "rFlag > " + lFlag);
		this.db.update(this.table, "lFlag = lFlag - 2", "lFlag > " + lFlag);
		this.db.del(this.table, "id = " + id);
		this.db.endTrans();
	}
}
</script>
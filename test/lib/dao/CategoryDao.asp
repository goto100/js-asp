<script language="javascript" runat="server">
function CategoryDao(id) {
	var db;
	var tblCategories = "Categories";
	var loadItems = [];
	var updateItem = {}
	var saveItem = {}

	var lFlag, rFlag;
	var lastCategory;

	this.fillCategory = null;
	this.fillSaveItem = null;
	this.fillUpdateItem = null;
}

CategoryDao.prototype.move = function(id, isDown) {
	if (isDown) {
		var bCategory = db.query("SELECT lFlag, rFlag FROM [" + tblCategories + "] WHERE id = " + id, 1);
		var aCategory = db.query("SELECT lFlag, rFlag FROM [" + tblCategories + "] WHERE lFlag = " + (bCategory.rFlag + 1), 1);
		if (!aCategory) return false;
	} else {
		var aCategory = db.query("SELECT lFlag, rFlag FROM [" + tblCategories + "] WHERE id = " + id, 1);
		var bCategory = db.query("SELECT lFlag, rFlag FROM [" + tblCategories + "] WHERE rFlag = " + (aCategory.lFlag - 1), 1);
		if (!bCategory) return false;
	}
	var subValue = aCategory.lFlag - bCategory.lFlag;
	var plusValue = aCategory.rFlag - bCategory.rFlag;
	db.doTrans(function() {
		db.update(tblCategories,
			"lFlag = - (lFlag + " + plusValue + "), rFlag = - (rFlag + " + plusValue + ")",
			"lFlag BETWEEN " + bCategory.lFlag + " AND " + bCategory.rFlag);
		db.update(tblCategories,
			"lFlag = lFlag - " + subValue + ", rFlag = rFlag - " + subValue,
			"lFlag BETWEEN " + aCategory.lFlag + " AND " + aCategory.rFlag);
		db.update(tblCategories,
			"lFlag = - lFlag, rFlag = - rFlag",
			"lFlag BETWEEN - " + (bCategory.lFlag + plusValue) + " AND - " + (bCategory.rFlag + plusValue));
	});
	return true;
}

CategoryDao.prototype.appendNode = function(node) {
	this[this.length++] = node;
}

CategoryDao.prototype.clear = function() {
	for (; this.length; this.length--) delete this[this.length];
}

CategoryDao.prototype.setDBSource = function(categoryDB) {
	db = categoryDB;
}

CategoryDao.prototype.load = function(withSubs) {
	if (!withSubs) { // Only one record
		var sql = "SELECT TOP 1 id, lFlag, rFlag";
		for (var i = 0; i < loadItems.length; i++) sql += ", " + loadItems[i];
		sql += " FROM [" + tblCategories + "] WHERE id = " + this.id;
		var record = db.query(sql, 1);
		if (!record) return 0;
		lFlag = record.rFlag;
		rFlag = record.lFlag;
		if (lFlag - rFlag == 1) this.isLeaf = true;
		this.fill(record);
		return this.id;
	}
	// Also get sub categories
	var sql = "SELECT id, parentId, lFlag, rFlag";
	for (var i = 0; i < loadItems.length; i++) sql += ", " + loadItems[i];
	sql += " FROM [" + tblCategories + "]";
	if (this.id) {
		var record = db.query("SELECT TOP 1 lFlag, rFlag FROM [" + tblCategories + "] WHERE id = " + this.id, 1);
		sql += " WHERE lFlag BETWEEN " + record.lFlag + " AND " + record.rFlag;
	}
	sql += " ORDER BY lFlag";

	var records = db.query(sql);
	if (!records) return false;

	for (var record; !records.atEnd(); records.moveNext()) {
		record = records.item();
		var category = new HuanCategory;
		category.fill(record);
		this.addCategory(category);
	}
	return true;
}

CategoryDao.prototype.addCategory = function(category) {
	if (category.parentCategory.id == 0) { // Root
		category.depth = 1;
		category.parentCategory = this;
		this.appendNode(category);
	} else if (category.parentCategory.id == lastCategory.id) { // Last node's node
		category.parentCategory = lastCategory;
		category.depth = category.parentCategory.depth + 1;
		lastCategory.appendNode(category);
	} else { // Last node's parent node's node
		var parentCategory = lastCategory.parentCategory;
		while (category.parentCategory.id != parentCategory.id) parentCategory = parentCategory.parentCategory;
		category.parentCategory = parentCategory;
		category.depth = category.parentCategory.depth + 1;
		parentCategory.appendNode(category);
	}
	lastCategory = category;
}

CategoryDao.prototype.fill = function(record) {
	this.id = record.id;
	this.parentCategory = {
		id: record.parentId
	}
	if (this.fillCategory) this.fillCategory(record);
}

CategoryDao.prototype.setParentCategory = function(id) {
	this.parentCategory = {
		id: id
	}
}

CategoryDao.prototype.up = function() {
	return move(this.id);
}

CategoryDao.prototype.down = function() {
	return move(this.id, true);
}

CategoryDao.prototype.save = function(value) {
	if (value) this.fill(value);

	if (this.parentCategory.id == 0) {
		var maxFlag = db.query("SELECT MAX(rFlag) AS maxFlag FROM [" + tblCategories + "]", 1).maxFlag;
		var saveItem = {
			parentId: 0,
			depth: 0,
			lFlag: maxFlag + 1,
			rFlag: maxFlag + 2
		}
		if (this.fillSaveItem) this.fillSaveItem(saveItem);
		db.insert(tblCategories, saveItem);
	} else {
		var pCate = db.query("SELECT depth, rFlag FROM [" + tblCategories + "] WHERE id = " + this.parentCategory.id, 1);

		db.doTrans(function() {
			db.update(tblCategories, "rFlag = rFlag + 2", "rFlag >= " + pCate.rFlag);
			db.update(tblCategories, "lFlag = lFlag + 2", "lFlag >= " + pCate.rFlag);
			var saveItem = {
				parentId: this.parentCategory.id,
				depth: pCate.depth + 1,
				lFlag: pCate.rFlag,
				rFlag: pCate.rFlag + 1
			}
			if (this.fillSaveItem) this.fillSaveItem(saveItem);
			db.insert(tblCategories, saveItem);
		});
	}
}

CategoryDao.prototype.update = function(value) {
	if (value) this.fill(value);
	if (this.fillUpdateItem) this.fillUpdateItem(updateItem);
	db.update(tblCategories, updateItem, "id = " + this.id);
}

CategoryDao.prototype.del = function() {
	if (!this.isLeaf) return false;

	var conn = db.getConnection();
	db.doTrans(function() {
		db.update(tblCategories, "rFlag = rFlag - 2", "rFlag > " + lFlag);
		db.update(tblCategories, "lFlag = lFlag - 2", "lFlag > " + lFlag);
		db.del(tblCategories, "id = " + this.id);
	});
}

CategoryDao.prototype.setTableName = function(categoryTableName) {
	tblCategories = categoryTableName;
}

CategoryDao.prototype.setLoadItems = function() {
	for (var i = 0; i < arguments.length; i++) loadItems.push(arguments[i]);
}
</script>
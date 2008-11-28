<!--#include file="HuanApplications.asp" -->
<!--#include file="HuanCache.asp" -->
<!--#include file="HuanCategory.asp" -->
<!--#include file="HuanCategories.asp" -->
<!--#include file="HuanSetting.asp" -->
<!--#include file="HuanSkin.asp" -->
<!--#include file="HuanSkins.asp" -->
<!--#include file="HuanVisitor.asp" -->
<!--#include file="HuanVisitors.asp" -->
<!--#include file="HuanUsers.asp" -->
<!--#include file="HuanUserGroup.asp" -->
<!--#include file="HuanUserGroups.asp" -->
<!--#include file="HuanUserMessage.asp" -->
<!--#include file="HuanUserMessages.asp" -->
<!--#include file="HuanVisitRecords.asp" -->
<script language="javascript" runat="server">
function HuanSystem(dbPath) {
	System.call(this, "huan");

	this.version = "0.1 beta";
	this.updateDate = new Date("2006/8/29");

	this.now = START_TIME;
	this.db = null;
	this.cache = null;
	this.setting = null;
	this.userGroups = null;

	this.load = function() {
		this.db = new DBAccess(dbPath);

		this.db.VISIT_RECORDS = "huan_VisitRecords";
		this.db.VISITORS = "huan_Visitors";
		this.db.USERS = "huan_Users";
		this.db.SETTINGS = "huan_Settings";
		this.db.USER_GROUPS = "huan_UserGroups";
		this.db.CATEGORIES = "huan_Categories";
		this.db.APPLICATIONS = "huan_Applications";
		this.db.MESSAGES = "huan_Messages";

		this.cache = new HuanCache(this);
		this.cache.load();
		this.setting = this.cache.setting.setting;
		this.userGroups = this.cache.userGroups.userGroups;
		Session.Timeout = this.setting.recordUsersTimeOut;
	}

	this.getVisitor = function(id, group) {
		var user = new HuanVisitor(this);
		user.id = id;
		user.group = group;

		return user;
	}

	this.getUsers = function() {
		return new HuanUsers(this);
	}

	this.getUserGroup = function(id) {
		var i, userGroup;
		for (i = 0; i < this.userGroups.length; i++) if (id == this.userGroups[i].id) {
			userGroup = new HuanUserGroup(this);
			userGroup.id = this.userGroups[i].id;
			userGroup.name = this.userGroups[i].name;
			userGroup.userCount = this.userGroups[i].userCount;
			userGroup.right = this.userGroups[i].right;

			return userGroup;
		}
	}

	this.getCategory = function(id) {
		var category = new HuanCategory(this);
		category.id = id;

		return category;
	}

	this.getUsers = function() {
		return new HuanUsers(system);
	}

	this.getVisitors = function() {
		return new HuanVisitors(this);
	}

	this.getApplications = function() {
		return new HuanApplications(this);
	}

	this.getVisitorCount = function() {
		var userCount = this.db.query("SELECT COUNT(id) AS userCount FROM " + this.table.users + " WHERE lastVisitTime > #" + DBAccess.checkDate(this.user.outlineTime) + "#", 1).userCount;
		var visitorCount = this.db.query("SELECT COUNT(id) AS visitorCount FROM " + this.table.visitors, 1).visitorCount;

		return userCount + visitorCount;
	}

	this.getUserCount = function() {
		return this.db.query("SELECT COUNT(id) AS userCount FROM " + this.table.users, 1).userCount;
	}

	this.getVisitRecordsCount = function() {
		return this.db.query("SELECT COUNT(*) AS visitRecordsCount FROM " + this.table.visitRecords, 1).visitRecordsCount;
	}
}
</script>
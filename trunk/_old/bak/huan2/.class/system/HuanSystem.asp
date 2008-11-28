<!--#include file="../application/HuanApplications.asp" -->
<!--#include file="../cache/HuanCache.asp" -->
<!--#include file="../category/HuanCategory.asp" -->
<!--#include file="../category/HuanCategories.asp" -->
<!--#include file="../setting/HuanSetting.asp" -->
<!--#include file="../skin/HuanSkin.asp" -->
<!--#include file="../skin/HuanSkins.asp" -->
<!--#include file="../user/HuanUser.asp" -->
<!--#include file="../user/HuanUsers.asp" -->
<!--#include file="../user/HuanMembers.asp" -->
<!--#include file="../usergroup/HuanUserGroup.asp" -->
<!--#include file="../usergroup/HuanUserGroups.asp" -->
<!--#include file="../usermessage/HuanUserMessage.asp" -->
<!--#include file="../usermessage/HuanUserMessages.asp" -->
<!--#include file="../visitor/HuanVisitors.asp" -->
<script language="javascript" runat="server">
function HuanSystem(dbPath) {
	System.apply(this, ["huan"]);

	this.version = "0.1 beta";
	this.updateDate = new Date("2006/8/29");

	this.now = START_TIME;
	this.db = null;
	this.cache = null;
	this.setting = null;
	this.userGroups = null;
	this.user = null;

	this.table = {
		visitors: "huan_Visitors",
		users: "huan_Users",
		members: "huan_Members",
		settings: "huan_Settings",
		userGroups: "huan_UserGroups",
		setting: "huan_Settings",
		categories: "huan_Categories",
		applications: "huan_Applications",
		messages: "huan_Messages"
	}

	this.load = function() {
		this.db = new DBAccess(dbPath);
		this.cache = new HuanCache(this);
		this.cache.load();
		this.setting = this.cache.setting.setting;
		this.userGroups = this.cache.userGroups.userGroups;
		this.user = this.getUser(0, this.getUserGroup(2));
		Session.Timeout = this.setting.recordUsersTimeOut;
	}

	this.getUser = function(id, group) {
		var user = new HuanUser(this);
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
			userGroup = new HuanUserGroup(system);
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

	this.getMembers = function() {
		return new HuanMembers(system);
	}

	this.getVisitors = function() {
		return new HuanVisitors(this);
	}

	this.getApplications = function() {
		return new HuanApplications(this);
	}

	this.getUserCount = function() {
		var memberCount = this.db.query("SELECT COUNT(id) AS memberCount FROM " + this.table.members + " WHERE lastVisitTime > #" + this.db.checkDate(this.user.outlineTime) + "#", 1).memberCount;
		var userCount = this.db.query("SELECT COUNT(id) AS userCount FROM " + this.table.users, 1).userCount;

		return memberCount + userCount;
	}

	this.getMemberCount = function() {
		return this.db.query("SELECT COUNT(id) AS memberCount FROM " + this.table.members, 1).memberCount;
	}

	this.getVisitorCount = function() {
		return this.db.query("SELECT COUNT(*) AS visitorCount FROM " + this.table.visitors, 1).visitorCount;
	}
}
</script>
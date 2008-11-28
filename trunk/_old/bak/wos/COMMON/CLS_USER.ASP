<%
////////////////////////////////////////////////////////////
// Class User
//
// Last modify: 2005/6/20
// Author: ScYui
//
// Attributes: 
// Methods: 
////////////////////////////////////////////////////////////

function User() {
	////////// Attributes //////////////////////////////
	// Private //////////
	var userGroups = theCache.userGroups;
	var returnMessage = [];

	// This is DVBBS's database infomation, you can change it to suppose other forums
	var forumDB = {"sheetName":"Dv_User", "colId":"UserId", "colName":"UserName", "colPassword":"UserPassword", "colGroupId":"UserGroupId", "colGender":"UserSex", "colEmail":"UserEmail"};

	// Public //////////
	this.conn = theSite.conn;

	this.loggedIn = false;

	this.id;
	this.name = "";
	this.password = "";
	this.group = {"id":1}; // Default a Guest
	this.gender;
	this.email = "";
	this.hiddenEmail = false;
	this.setting = [];
	this.homepage = "";
	this.lastVisit;
	this.lastIP = "";
	this.articleCount;
	this.commentCount;

	////////// Methods //////////////////////////////
	// Private //////////

	// Public //////////

	// User register
	this.register = function() {
	}

	// User login
	this.login = function(strUsername, strPassword, intCookieDays, strSCode, bNoSCode) {
		intCookieDays = checkInt(intCookieDays);
		if (!intCookieDays){
			intCookieDays = 1;
		}

		if (theCache.setting["enableSecurityCode"]) {
			if (!strSCode) return getLang("security_code") + getLang("incomplete");
			if (strSCode != getSession("SecurityCode")) return getLang("security_code_wrong");
		}

		var tDate = new Date();
		tDate.setTime(tDate.getTime() + intCookieDays * 864E5);

		var tmpA = this.conn.query("SELECT TOP 1 user_id, user_forumUserId, user_name, user_password, user_groupId"
			+ " FROM [site_Users]"
			+ " WHERE user_name='" + strUsername + "'");

		// Not find in main database, find in forum database
		if (!tmpA) {
			var connForum = new DBConn(theSite.plugin.Forum.dbPath);
			tmpA = connForum.query("SELECT TOP 1 " + forumDB.colId + ", " + forumDB.colName + ", " + forumDB.colPassword + ", " + forumDB.colGroupId + ", " + forumDB.colGender + ", " + forumDB.colEmail
			+ " FROM [" + forumDB.sheetName + "]"
			+ " WHERE " + forumDB.colName + "='" + strUsername + "'");
			connForum.close();
			delete connForum;

			if (!tmpA) {
				return getLang("no_user");
			} else { // Forum user first time login
				// Update forum user's infomation to main database
				this.conn.insert("[site_Users]", {"user_forumUserId":tmpA[forumDB.colId]
																				, "user_name":tmpA[forumDB.colName]
																				, "user_password":tmpA[forumDB.colPassword]
																				, "user_groupId":1
																				, "user_gender":(tmpA[forumDB.colGender] == 0? 2: 1)
																				, "user_email":tmpA[forumDB.colEmail]
																				}
												);
				tmpA = this.conn.query("SELECT TOP 1 user_id, user_forumUserId, user_name, user_password, user_groupId"
					+ " FROM [site_Users]"
					+ " WHERE user_name='" + strUsername + "'");
			}
		}

		if (tmpA != null) {
			if (tmpA["user_password"] == theSite.encode(strPassword)) {
				Response.Cookies(theSite.nameSpace + "userid") = tmpA["user_id"];
				Response.Cookies(theSite.nameSpace + "userid").Expires = tDate.getVarDate();
				this.fill(tmpA);
				this.loggedIn = true;
				returnMessage.push(getLang("login_success_desc"));
			} else {
				returnMessage.push(getLang("password_error"));
			}
			return [returnMessage];
		}
	}

	// User logout
	this.logout = function() {
		Response.Cookies(theSite.nameSpace + "userid") = undefined;
		this.loggedIn = false;
	}

	// Fill user object
  this.fill = function(arr){
		if (arr["user_id"]) this.id = arr["user_id"];
		this.username = arr["user_name"];
		this.password = arr["user_password"];
		// this.salt = arr["user_salt"];
		this.group.id = arr["user_groupId"];
		this.group.name = arr["user_groupName"];
		switch(arr["user_gender"]) {
			case 0:this.gender = getLang("secret"); break;
			case 1:this.gender = getLang("male"); break;
			case 2:this.gender = getLang("female"); break;
		}
		this.email = arr["user_email"];
		// this.hideEmail = arr["user_hideemail"];
		this.website = arr["user_website"];
		// this.lastVisit = new Date(Number(arr["user_lastvisit"]));
		// this.lastIP = arr["user_ip"];
		// this.articleCount = arr["user_articlecount"];
		// this.commentCount = arr["user_commentcount"];
		this.getUserRight();
  }

	// Get user right
	this.getUserRight = function() {
		for (var i = 0; i < userGroups.length; i++) {
			if (this.group.id == userGroups[i].id) {
				this.group.name = userGroups[i].name;
				this.right = userGroups[i].right;
				return;
			}
		}
	}

	// Edit user's profile
	this.edit = function(strNewPassword) {
		var sql = {	"user_groupId":this.group.id
							, "user_gender":this.gender
							, "user_email":this.email
							, "user_website":this.website
							}
		if (strNewPassword) {
			sql["user_password"] = theSite.encode(strNewPassword);
			returnMessage.push(getLang("password_changed"));
		}

		this.conn.update("[site_Users]", sql, "user_id=" + this.id);

		returnMessage.push(getLang("user_profile") + getLang("edit_success"));
		return [returnMessage, 1];
	}
}
%>
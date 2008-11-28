<%
// Get user's profile by Id
theSite.getUser = function(intId, arr) {
	var sql = "SELECT TOP 1 ";
	if (arr) {
		for (var i = 0; i < arr.length; i++) {
			sql += (arr[i] + ", ");
		}
		sql = sql.slice(0, -2);
	} else {
		sql += "*";
	}
	sql += " FROM [site_Users]"
		+ " WHERE user_id=" + intId;
	var tmpA = theSite.conn.query(sql);
	if (tmpA != null) {
		var user = new User();
		user.fill(tmpA);

		return user;
	}
}

// Get users
theSite.getUsers = function(intGroupId) {
	var tmpA = theSite.conn.query("SELECT u.user_id, u.user_name, g.group_name"
		+ " FROM [site_Users] AS u, [site_UserGroups] AS g"
		+ " WHERE u.user_groupId=g.group_id"
		+ (intGroupId && intGroupId != 0? (" AND u.user_groupId=" + intGroupId): "")
		+ " ORDER BY u.user_id");
	if (tmpA != null) {
		var users = [];
		for (var i = 0; i < tmpA.length; i++) {
			users[i] = [];
			var e = tmpA[i].getExpandoNames();
			for (var j = 0; j < e.length; j++) {
				users[i][e[j].replace("user_", "")] = tmpA[i][e[j]];
			}
			users[i].groupName = tmpA[i]["group_name"];
		}

		return users;
	}
}

theSite.getGroups = function(arr) {
	var sql = "SELECT ";
	if (arr) {
		for (var i = 0; i < arr.length; i++) {
			sql += arr[i] + ", ";
		}
		sql = sql.slice(0, -2);
	} else {
		sql += "*";
	}
	sql += " FROM [site_UserGroups]"
		+ " WHERE group_id<>1" // No guest group
		+ " ORDER BY group_id";
	var tmpA = theSite.conn.query(sql);
	if (tmpA != null) {
		var userGroups = [];
		for (var i = 0; i < tmpA.length; i++) {
			userGroups[i] = new Array;
			var e = tmpA[i].getExpandoNames();
			for (var j = 0; j < e.length; j++) {
				userGroups[i][e[j].replace("group_", "")] = tmpA[i][e[j]];
			}
		}
		return userGroups;
	}
}

switch(query["act"]) {
	case "edit":
		if (!theUser.right.manage && theUser.id != query["id"]) {
			thePage.outputAlert(getLang("no_right_desc"));
		}
		outputEdit(theSite.getUser(query["id"]), theCache.userGroups);
		break;

	case "doedit":
		if (!query["id"]) {
			thePage.outputAlert(getLang("bad_request"));
		} else if (!theUser.right.manage && theUser.id != query["id"]) {
			thePage.outputAlert(getLang("no_right_desc"));
		} else {
			var tUser = new theSite.getUser(query["id"], ["user_id"]);

			// Manager can edit user's group, but only group except user's password is right
			if (theUser.right.manage && input["user_groupId"]) {
				if (!input["user_password"]) { // No password, so only update group
					var tmp = input["user_groupId"];
					delete input;
					var input = {"user_groupId":tmp};
				} else {
					var userPassword = theSite.conn.query("SELECT TOP 1 user_password"
						+ " FROM [site_Users]"
						+ " WHERE user_id=" + query["id"])["user_password"];

					if (theSite.encode(input["user_password"]) != userPassword) { // Password error
						thePage.outputAlert(getLang("password_error"));
					}
					if (input["user_newPassword"] != input["user_confirmPassword"]) {
						thePage.outputAlert(getLang("two_password_diffirent"));
					}
				}
			} else {
				if (!input["user_password"]) {
					thePage.outputAlert(getLang("password") + getLang("incomplete"));
				} else if (input["user_groupId"]) { // user can't edit hiselves group
					thePage.outputAlert(getLang("no_right_desc"));
				} else {
					var userPassword = theSite.conn.query("SELECT TOP 1 user_password"
						+ " FROM [site_Users]"
						+ " WHERE user_id=" + query["id"])["user_password"];

					if (theSite.encode(input["user_password"]) != userPassword) { // Password error
						thePage.outputAlert(getLang("password_error"));
					}
					if (input["user_newPassword"] != input["user_confirmPassword"]) {
						thePage.outputAlert(getLang("two_password_diffirent"));
					}
				}
			}
			tUser.fill(input);
			thePage.outputAlert(tUser.edit(input["user_newPassword"]));
		}
		break;

	case "":
		break;

	default:
		if (query["id"]) {
			outputUser(theSite.getUser(query["id"]));
		} else {
			outputUsers(theSite.getUsers(query["group"]), theSite.getGroups());
		}
}
%>
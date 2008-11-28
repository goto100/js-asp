<%
theSite.getUserGroups = function() {
	var tmpA = theSite.conn.query("SELECT *"
		+ " FROM [site_UserGroups]"
		+ " ORDER BY group_id");
	if (tmpA != null) {
		var userGroups = [];
		for (var i = 0; i < tmpA.length; i++) {
			userGroups[i] = [];
			var e = tmpA[i].getExpandoNames();
			for (var j = 0; j < e.length; j++) {
				userGroups[i][e[i].replace("group_", "")] = tmpA[i][e[i]];
			}
		}
		return userGroups;
	}
}

theSite.submitUserGroup = function(arr) {
	var messages = [];

	// Delete selected groups
	if (arr["group_delete"]) {
		var deletes = arr["group_delete"].split(", ");
		if (deletes) {
			for (var i = 0; i < deletes.length; i++) {
				if (deletes[i] == 1 || deletes[i] == 2 || deletes[i] == 3) continue; // Base groups can't delete
				theSite.conn.del("site_UserGroups", "group_id=" + deletes[i]);
				theSite.conn.del("site_Users", "user_groupId=" + deletes[i]);
			}
			messages.push(getLang("user_group") + getLang("delete_success"));
		}
	}

	var ids = arr["group_id"].split(", ");
	var names = arr["group_name"].split(", ");

	for (var i = 0; i < ids.length; i++) {
		// Edit smile icons
		if (ids[i] != 0) {
			theSite.conn.update("[site_UserGroups]", {"group_name":names[i]}, "group_id=" + ids[i]);
		}
		// Add an smile icon
		if (ids[i] == 0 && names[i] != "") {
			theSite.conn.insert("[site_UserGroups]", {"group_name":names[i]}, "group_id=" + ids[i]);
			messages.push(getLang("user_group") + getLang("add_success"));
		}
	}
	messages.push(getLang("user_group") + getLang("edit_success"));

	return [messages, 1];
}

switch(query["act"]) {
	case "submit":
		thePage.outputAlert(theSite.submitUserGroup(input));
		theCache.loadUserGroups();
		break;

	default:
		outputUserGroup(theSite.getUserGroups());
}
%>
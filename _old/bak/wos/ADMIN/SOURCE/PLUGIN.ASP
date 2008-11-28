<%
// Get plugin
theSite.getPlugins = function() {
	var tmpA = theSite.conn.query("SELECT plug_name, plug_dbPath, plug_folder"
		+ " FROM [site_Plugin]"
		+ " ORDER BY plug_name");
	if (tmpA != null) {
		var plugins = [];
		for (var i = 0; i < tmpA.length; i++) {
			plugins[i] = [];
			var e = tmpA[i].getExpandoNames();
			for (var j = 0; j < e.length; j++) {
				plugins[i][e[j].replace("plug_", "")] = tmpA[i][e[j]];
			}
			plugins[i].adminFolder = (theCache.setting.sitePath + "/apps/" + plugins[i].folder + "admin/");
		}
		return plugins;
	}
}

// Edit, add, delete Plugins
theSite.submitPlugin = function(arrItems) {
	var messages = [];

	// Delete selected icons
	if (arrItems["plug_delete"]) {
		var deletes = arrItems["plug_delete"].split(", ");
		if (deletes) {
			for (var i = 0; i < deletes.length; i++) {
				theSite.conn.del("site_Plugin", "plug_id=" + deletes[i]);
			}
			messages.push(getLang("plugin") + getLang("delete_success"));
		}
	}

	var ids = arrItems["plug_id"].split(", ");
	var names = arrItems["plug_name"].split(", ");
	var dbPaths = arrItems["plug_dbPath"].split(", ");
	var folders = arrItems["plug_folder"].split(", ");

	for (var i = 0; i < ids.length; i++) {
		// Edit plugins
		if (ids[i] != 0) {
			if (!DBConn.checkDBConn(dbPaths[i])) {
				messages.push(lang[names[i]] + getLang("database_connection_false"));
				return messages;
			} else {
				theSite.conn.update("[site_Plugin]", {"plug_name":names[i], "plug_dbPath":dbPaths[i], "plug_folder":folders[i]}, "plug_id=" + ids[i]);
			}
		}
		// Add a plugin
		if (ids[i] == 0 && names[i] != "" && folders[i] != "") {
			if (!DBConn.checkDBConn(dbPaths[i])) {
				messages.push(lang[names[i]] + getLang("database_connection_false"));
				return messages;
			} else {
				theSite.conn.insert("[site_Plugin]", {"plug_name":names[i], "plug_dbPath":dbPaths[i], "plug_folder":folders[i]}, "plug_id=" + ids[i]);
				messages.push(getLang("plugin") + getLang("add_success"));
			}
		}
	}
	messages.push(getLang("plugin") + getLang("edit_success"));

	return [messages, 1];
}

switch(query["act"]) {
	case "submit":
		thePage.outputAlert(theSite.submitPlugin(input));
		break;

	default:
		outputPlugin(theSite.getPlugins());
}
%>
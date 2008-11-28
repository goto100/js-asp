<%
// There are two Class Global's methods, it's put here is better

// Get smile icons
theSite.getSmiles = function() {
	var tmpA = theSite.conn.query("SELECT sm_id, sm_name, sm_file"
		+ " FROM [site_Smiles]"
		+ " ORDER BY sm_name");
	if (tmpA != null) {
		var smiles = [];
		for (var i = 0; i < tmpA.length; i++) {
			smiles[i] = [];
			var e = tmpA[i].getExpandoNames();
			for (var j = 0; j < e.length; j++) {
				smiles[i][e[j].replace("sm_", "")] = tmpA[i][e[j]];
			}
			smiles[i].filePath = "../" + theCache.setting.smilesFolder + smiles[i].file;
		}
		return smiles;
	}
}

// Edit, add, delete smiles
theSite.submitSmile = function(arr) {
	var messages = [];

	// Delete selected icons
	if (arr["sm_delete"]) {
		var deletes = arr["sm_delete"].split(", ");
		if (deletes) {
			for (var i = 0; i < deletes.length; i++) {
				theSite.conn.del("site_Smiles", "sm_id=" + deletes[i]);
			}
			messages.push(getLang("smile_icon") + getLang("delete_success"));
		}
	}

	var ids = arr["sm_id"].split(", ");
	var names = arr["sm_name"].split(", ");
	var files = arr["sm_file"].split(", ");

	for (var i = 0; i < ids.length; i++) {
		// Edit smile icons
		if (ids[i] != 0) {
			theSite.conn.update("[site_Smiles]", {"sm_name":names[i], "sm_file":files[i]}, "sm_id=" + ids[i]);
		}
		// Add an smile icon
		if (ids[i] == 0 && names[i] != "" && files[i] != "") {
			theSite.conn.insert("[site_Smiles]", {"sm_name":names[i], "sm_file":files[i]}, "sm_id=" + ids[i]);
			messages.push(getLang("smile_icon") + getLang("add_success"));
		}
	}
	messages.push(getLang("smile_icon") + getLang("edit_success"));

	return [messages, 1];
}

switch(query["act"]) {
	case "submit":
		var alert = theSite.submitSmile(input);
		theCache.loadSmiles();
		thePage.outputAlert(alert);
		break;

	default:
		outputList(theSite.getSmiles());
}
%>
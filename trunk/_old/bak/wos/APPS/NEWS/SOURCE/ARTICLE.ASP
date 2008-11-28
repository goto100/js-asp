<%
switch(query["act"]) {
	case "add":
		outputForm(false, appNews.getCategories());
		break;

	case "edit":
		outputForm(true, appNews.getCategories(), appNews.getArticle(query["id"]));
		break;

	case "doadd":
		thePage.outputAlert(appNews.addArticle(input["arti_cateId"]
																	, input["arti_publisherId"]
																	, input["arti_publisherName"]
																	, input["arti_builtFile"]
																	, input["arti_fileFolder"]
																	, input["arti_fileName"]
																	, input["arti_fileType"]
																	, input["arti_title"]
																	, input["arti_source"]
																	, input["arti_sourceLink"]
																	, input["arti_summary"]
																	, input["arti_content"]
																	)
												);
		break;

	case "doedit":
	tArticle.edit = function() {
		var tArticle = appNews.getArticle(query["id"]);

		input["arti_setting"] = (input["arti_setting_html"]? "1":"0");
		input["arti_setting"] += (input["arti_setting_ubb"]? "1":"0");
		input["arti_setting"] += (input["arti_setting_url"]? "1":"0");
		input["arti_setting"] += (input["arti_setting_image"]? "1":"0");
		input["arti_setting"] += (input["arti_setting_media"]? "1":"0");
		input["arti_setting"] += (input["arti_setting_smile"]? "1":"0");

		tArticle.fill(input);

		if (!this.cateId) returnMessage.push(getLang("category") + getLang("unselected"));
		if (!this.title) returnMessage.push(getLang("title") + getLang("incomplete"));
		if (!this.content) returnMessage.push(getLang("content") + getLang("incomplete"));
		if (this.builtFile == true) {
			if (this.builtSetting == 0) {
			} else if (this.builtSetting == 1) {
				if (!this.fileFolder) returnMessage.push(getLang("built_file_folder") + getLang("incomplete"));
				if (!this.fileName) returnMessage.push(getLang("file_name") + getLang("incomplete"));
				if (!this.fileType) returnMessage.push(getLang("type") + getLang("unselected"));
			}
		}
		if (returnMessage[0] != null) return [returnMessage];
		if (this.content.length<2) return getLang("content_too_short");
	}

		thePage.outputAlert(tArticle.edit(input));
		break;

	case "dodel":

		break;

	default:
		Response.Redirect("default.asp");

}
%>
<%
theSite.getSetting = function() {
	var tmpA = theSite.conn.query("SELECT *"
		+ " FROM [site_Setting]");
	if (tmpA != null) {
		var setting = [];
		for (var i = 0; i < tmpA.length; i++) {
			setting[tmpA[i]["set_name"]] = (tmpA[i]["set_type"] == 0? tmpA[i]["set_value0"]:tmpA[i]["set_value1"]);
		}
		return setting;
	}
}
theSite.submitSetting = function(arrInput) {
	var returnMessage = [];

	if (!arrInput["siteName"]) returnMessage.push(getLang("site_name") + getLang("incomplete"));
	if (!arrInput["siteURL"]) returnMessage.push(getLang("site_url") + getLang("incomplete"));
	if (returnMessage[0] != undefined) {
		thePage.outputAlert([returnMessage]);
	} else {
		theSite.conn.update("[site_Setting]", {"set_value1": arrInput["siteName"]}, "set_name='siteName'");
		theSite.conn.update("[site_Setting]", {"set_value1": arrInput["siteDescription"]}, "set_name='siteDescription'");
		theSite.conn.update("[site_Setting]", {"set_value1": arrInput["siteURL"]}, "set_name='siteURL'");
		theSite.conn.update("[site_Setting]", {"set_value1": arrInput["sitePath"]}, "set_name='sitePath'");
		theSite.conn.update("[site_Setting]", {"set_value1": arrInput["siteCloseDesc"]}, "set_name='siteCloseDesc'");
		theSite.conn.update("[site_Setting]", {"set_value1": arrInput["siteWebmaster"]}, "set_name='siteWebmaster'");
		theSite.conn.update("[site_Setting]", {"set_value1": arrInput["siteWebMasterEmail"]}, "set_name='siteWebMasterEmail'");
		theSite.conn.update("[site_Setting]", {"set_value1": arrInput["defaultSkin"]}, "set_name='defaultSkin'");
		theSite.conn.update("[site_Setting]", {"set_value1": arrInput["defaultLang"]}, "set_name='defaultLang'");
		theSite.conn.update("[site_Setting]", {"set_value1": arrInput["defaultStyle"]}, "set_name='defaultStyle'");
		theSite.conn.update("[site_Setting]", {"set_value1": arrInput["smilesFolder"]}, "set_name='smilesFolder'");
		return [getLang("setting") + getLang("edit_success"), 1];
	}
}

// Get skins' codeName and name for list
theSite.getSkins = function() {
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	var folders = fso.getFolder(Server.MapPath(theCache.setting.sitePath + "/skins/")).subFolders;
	var e = new Enumerator(folders);
	var skins = [];
	var xmlDom = new ActiveXObject("MSXML2.DomDocument");
	xmlDom.async = false;
	for (; !e.atEnd(); e.moveNext()) {
		xmlDom.load(e.item().path + "\\config.xml");
		var skin = {};
		skin.codeName = e.item().name;
		skin.name = xmlDom.documentElement.selectSingleNode("//skin/name").text;
		skins.push(skin);
	}
	return skins;
}

// Get one skin's all infomation
theSite.getSkin = function(strCodeName, bXML) {
	var xmlDom = new ActiveXObject("MSXML2.DomDocument");
	xmlDom.async = false;
	xmlDom.load(Server.MapPath(theCache.setting.sitePath + "/skins/" + strCodeName + "/config.xml"));
	if (bXML) {
		var fso = new ActiveXObject("Scripting.FileSystemObject");

		// New element langs
		var langs = xmlDom.createElement("langs");
		var folders = fso.getFolder(Server.MapPath(theCache.setting.sitePath + "/skins/" + strCodeName + "/langs")).subFolders;
		var e = new Enumerator(folders);
		for (; !e.atEnd(); e.moveNext()) {
			var newLang = xmlDom.createElement("lang");
			newLang.text = e.item().name;
			langs.appendChild(newLang);
		}

		// New element styles
		var styles = xmlDom.createElement("styles");
		var folders = fso.getFolder(Server.MapPath(theCache.setting.sitePath + "/skins/" + strCodeName + "/styles")).subFolders;
		var e = new Enumerator(folders);
		for (; !e.atEnd(); e.moveNext()) {
			var newStyle = xmlDom.createElement("style");
			newStyle.text = e.item().name;
			styles.appendChild(newStyle);
		}

		xmlDom.documentElement.appendChild(langs);
		xmlDom.documentElement.appendChild(styles);
		Response.ContentType = "text/xml";
		write(xmlDom.documentElement.xml);
		Response.End();
	} else {
		var skin = {};
		skin.codeName = strCodeName;
		skin.name = xmlDom.documentElement.selectSingleNode("//skin/name").text;
		skin.version = xmlDom.documentElement.selectSingleNode("//skin/version").text;
		skin.description = xmlDom.documentElement.selectSingleNode("//skin/description").text;
		skin.author = {};
		skin.author.name = xmlDom.documentElement.selectSingleNode("//skin/author/name").text;
		skin.author.email = xmlDom.documentElement.selectSingleNode("//skin/author/email").text;
		skin.author.url = xmlDom.documentElement.selectSingleNode("//skin/author/url").text;
		var fso = new ActiveXObject("Scripting.FileSystemObject");

		skin.langs = [];
		var folders = fso.getFolder(Server.MapPath(theCache.setting.sitePath + "/skins/" + strCodeName + "/langs")).subFolders;
		var e = new Enumerator(folders);
		for (; !e.atEnd(); e.moveNext()) {
			var lang = {};
			lang.name = e.item().name;
			skin.langs.push(lang);
		}
		skin.styles = [];
		var folders = fso.getFolder(Server.MapPath(theCache.setting.sitePath + "/skins/" + strCodeName + "/styles")).subFolders;
		var e = new Enumerator(folders);
		for (; !e.atEnd(); e.moveNext()) {
			var style = {};
			style.name = e.item().name;
			skin.styles.push(style);
		}

		return skin;
	}
}

if (query["getskin"]) {
	theSite.getSkin(query["getskin"], true);
}
switch(query["act"]) {
	case "submit":
		var alert = theSite.submitSetting(input);
		theCache.loadSetting();
		thePage.outputAlert(alert);
		break;

	default:
		outputSetting(theSite.getSetting(), theSite.getSkins(), theSite.getSkin(theCache.setting.defaultSkin));

}
%>
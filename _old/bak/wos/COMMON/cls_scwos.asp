<!-- #include file = "cls_dbconn.asp" -->
<!-- #include file = "cls_cache.asp" -->
<!-- #include file = "cls_user.asp" -->
<%
////////////////////////////////////////////////////////////
// Class ScWOS
//
// Last modify: 2005/6/20
// Author: ScYui
//
// Attributes: 
// Methods: 
////////////////////////////////////////////////////////////
function ScWOS() {
	////////// Attributes //////////////////////////////
	// Private //////////

	// Public //////////
	this.cache = new WOSCache();
	this.user = new Object();
	this.conn;

	this.version = "v.1 beta";
	this.processTime = Number(new Date());
	this.siteDBPath = "";
	this.nameSpace = "";
	this.debugMode = false; // debug mode will output database infomation in the end of the page

	////////// Methods //////////////////////////////
	// Private //////////

	// Public //////////
	// Make connection
	this.load = function() {
		this.conn = new DBConn(this.siteDBPath);
	}

	// Open site when site closed
	this.open = function() {
		this.conn.update("[site_Setting]", {"set_value0":1}, "set_name='siteOpened'");
		theCache.cleanAll();
	}

	// Close site when site opend
	this.close = function() {
		this.conn.update("[site_Setting]", {"set_value0":0}, "set_name='siteOpened'");
		theCache.cleanAll();
	}

	// Add a plugin to Cache
	this.loadPlugin = function(strName, strDBPath) {
		theCache.plugin[strName] = {"dbPath":strDBPath};
	}

	// Get all Request.QueryString to query
	this.getQuery = function() {
		var query = [];
		var e = new Enumerator(Request.QueryString);
		for (; !e.atEnd(); e.moveNext()) {
			x = e.item();
			query[String(x)] = String(Request.QueryString(x));
		}
		return query;
	}

	// Get all Request.Form to input
	this.getInput = function() {
		var input = [];
		e = new Enumerator(Request.Form);
		for (; !e.atEnd(); e.moveNext()) {
			x = e.item();
			input[String(x)] = String(Request.Form(x));
		}
		return input;
	}

	// Check user cookies
	this.checkCookies = function() {
		this.user = new User();
		if (!String(Request.Cookies(theSite.nameSpace + "userid"))) {
			this.user.logout(false);
		} else {
			var intUserId = checkInt(Request.Cookies(theSite.nameSpace + "userid"));
			var tmpA = this.conn.query("SELECT TOP 1 user_id, user_name, user_groupId"
				+ " FROM [site_Users]"
				+ " WHERE user_id=" + intUserId);
			if (tmpA != null) {
				this.user.loggedIn = true;
				this.user.fill(tmpA);
			} else {
				this.user.logout(false);
			}
		}

		return this.user;
	}

	// Get user groups
	// It's in admin/usergroup.asp and user.asp
	this.getUserGroups = function() {
		var tmpA = this.conn.query("SELECT *"
			+ " FROM [site_userGroups]"
			+ " ORDER BY group_name");
		if (tmpA != null) {
			var userGroups = [];
			for (var i = 0; i < tmpA.length; i++) {
				userGroups[i] = [];
				var e = tmpA[i].getExpandoNames();
				for (var j = 0; j < e.length; j++) {
					userGroups[i][e[j].replace("group_", "")] = tmpA[i][e[j]];
				}
			}
			return userGroups;
		}
	}

	this.getLanguageArray = function() {
		if (this.cache.loaded == false) this.cache.load();

		var lang = [];
		var xmlDom = new ActiveXObject("MSXML2.DomDocument");
		xmlDom.async = false;
		xmlDom.load(Server.MapPath(this.cache.setting.sitePath + "/skins/default/langs/" + this.cache.setting.defaultLang + "/lang.xml"));
		//xmlDom.onreadystatechange = function() {
			if (xmlDom.readyState == 4) {
				if (arguments.length > 0) {
					for (var i = 0; i < arguments.length; i++) {
						var langs = xmlDom.documentElement.getElementsByTagName(arguments[i])[0].getElementsByTagName("lang");
						for (var j = 0; j < langs.length; j++) {
							lang[langs[j].getAttributeNode("name").nodeValue] = langs[j].text;
						}
					}
				} else { // Get all lang in this file
					var langs = xmlDom.documentElement.getElementsByTagName("lang");
					for (var i = 0; i < langs.length; i++) {
						lang[langs[i].getAttributeNode("name").nodeValue] = langs[i].text;
					}
				}
		
				return lang;
			}
		//}
	}

	// The MD5 function -----------------------------------------
	this.encode = function(str){
		var inLBS=true;
	%>
		<!-- #include file = "md5.asp" -->
	<%
		return MD5(str, 16);
	}
}
%>
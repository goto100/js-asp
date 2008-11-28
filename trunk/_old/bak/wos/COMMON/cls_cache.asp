<%
////////////////////////////////////////////////////////////
// Class WOSCache
//
// Last modify: 2005/6/20
// Author: ScYui
//
// Attributes: 
// Methods: 
////////////////////////////////////////////////////////////

function WOSCache() {
	////////// Attributes //////////////////////////////
	// Private //////////

	// Public //////////
	this.loaded = false;

	this.setting = [];
	this.categories = [];
	this.userGroups = [];
	this.smiles = [];
	this.plugin = [];

	////////// Methods //////////////////////////////
	// Private //////////

	// Public //////////

	// Load all caches
	this.load = function() {
		if (Application(theSite.nameSpace + "CacheSetting") != undefined) {
			this.fillSetting(Application(theSite.nameSpace + "CacheSetting"));
		} else {
			this.loadSetting();
		}
		if (Application(theSite.nameSpace + "CacheCategories") != undefined) {
			this.fillCategories(Application(theSite.nameSpace + "CacheCategories"));
		} else {
			this.loadCategories();
		}
		if (Application(theSite.nameSpace + "CacheUserGroup") != undefined) {
			this.fillUserGroup(Application(theSite.nameSpace + "CacheUserGroup"));
		} else {
			this.loadUserGroup();
		}
		if (Application(theSite.nameSpace + "CacheSmiles") != undefined) {
			this.fillSmiles(Application(theSite.nameSpace + "CacheSmiles"));
		} else {
			this.loadSmiles();
		}
		if (Application(theSite.nameSpace + "CachePlugin") != undefined) {
			this.fillPlugin(Application(theSite.nameSpace + "CachePlugin"));
		} else {
			this.loadPlugin();
		}
		this.loaded = true;
	}

	// Load setting
	this.loadSetting = function() {
		this.saveToCache(theSite.nameSpace + "CacheSetting", "none");
		var tmpA = theSite.conn.query("SELECT *"
			+ " FROM [site_Setting]", undefined, undefined, true);
		if (tmpA != null) {
      if (tmpA.ubound(2)>-1) {
				this.saveToCache(theSite.nameSpace + "CacheSetting", tmpA);
				this.fillSetting(tmpA);
			}
		}
	}

	// Fill setting
	this.fillSetting = function(arr) {
		if (arr == "none") return;
		this.settingCount=arr.ubound(2);
		for (var i = 0; i <= arr.ubound(2); i++) {
			var tValue = (arr.getItem(1, i) == 0)? arr.getItem(2, i): arr.getItem(3, i);
			this.setting[arr.getItem(0, i)] = tValue;
		}
	}

	// Load categories
	this.loadCategories = function() {
    this.saveToCache(theSite.nameSpace + "CacheCategories", "none");
    var tmpA = theSite.conn.query("SELECT *"
			+ " FROM [site_Categories]"
			+ " WHERE cate_hidden=FALSE"
			+ " ORDER BY cate_rootOrder, cate_order", undefined, undefined, true);
    if (tmpA != null) {
      if (tmpA.ubound(2)>-1) {
        this.saveToCache(theSite.nameSpace + "CacheCategories", tmpA);
        this.fillCategories(tmpA);
      }
    }
    delete tmpA;
	}

	// Fill categories
  this.fillCategories = function(arr) {
    if (arr == "none") return;
    var count = arr.ubound(2);
    for (var i = 0; i <= count; i++) {
			this.categories[i] = {"id":arr.getItem(0, i)
													,	"name":arr.getItem(1, i)
													, "intro":arr.getItem(2, i)
													, "rootId":arr.getItem(3, i)
													, "rootOrder":arr.getItem(4, i)
													, "order":arr.getItem(5, i)
													, "url":arr.getItem(6, i)
														};
    }
  }

	// Load user groups
	this.loadUserGroup = function() {
		this.saveToCache(theSite.nameSpace + "CacheUserGroup", "none");
		var tmpA = theSite.conn.query("SELECT group_id, group_name, group_rights"
			+ " FROM [site_UserGroups]"
			+ " ORDER BY group_id", undefined, undefined, true);
		if (tmpA != null) {
      if (tmpA.ubound(2)>-1) {
				this.saveToCache(theSite.nameSpace + "CacheUserGroup", tmpA);
				this.fillUserGroup(tmpA);
			}
    }
    delete tmpA;
	}

	// Fill user groups
	this.fillUserGroup = function(arr) {
		if (arr == "none") return;
		var count = arr.ubound(2);
		for (var i = 0; i <= count; i++) {
			var strRight = arr.getItem(2, i);
			var arrRight = [];
			arrRight = strRight.split(",");
			var manageRight = arr.getItem(0, i) == 1? true: false;
			this.userGroups[i] = {"id":arr.getItem(0, i)
													, "name":arr.getItem(1, i)
													, "right":{	"view":checkInt(arrRight[0])
																		, "post":checkInt(arrRight[1])
																		, "edit":checkInt(arrRight[2])
																		, "del":checkInt(arrRight[3])
																		, "upload":checkInt(arrRight[4])
																		, "search":checkInt(arrRight[5])
																		, "manage":true
																		}
													};
		}
	}

	// Load smiles
	this.loadSmiles = function() {
    this.saveToCache(theSite.nameSpace + "CacheSmiles", "none");
    var tmpA = theSite.conn.query("SELECT sm_name, sm_file"
			+ " FROM [site_Smiles]"
			+ " ORDER BY sm_name", undefined, undefined, true);
    if (tmpA != null) {
      if (tmpA.ubound(2)>-1) {
        this.saveToCache(theSite.nameSpace + "CacheSmiles", tmpA);
        this.fillSmiles(tmpA);
      }
    }
    delete tmpA;
	}

	// Fill smiles
	this.fillSmiles = function(arr) {
    if (arr == "none") return;
    var count = arr.ubound(2);
    for (var i = 0; i <= count; i++) {
			this.smiles[i] = {"name":arr.getItem(0, i)
												, "file":arr.getItem(1, i)
												,	"filePath":theCache.setting.smilesFolder + arr.getItem(1, i)
													};
    }
	}

	// Load plugin
	this.loadPlugin = function() {
		this.saveToCache(theSite.nameSpace + "CachePlugin", "none");
		var tmpA = theSite.conn.query("SELECT plug_name, plug_dbPath, plug_folder"
			+ " FROM [site_Plugin]", undefined, undefined, true);
		if (tmpA != null) {
      if (tmpA.ubound(2)>-1) {
				this.saveToCache(theSite.nameSpace + "CachePlugin", tmpA);
				this.fillPlugin(tmpA);
			}
		}
	}

	// Fill plugin
	this.fillPlugin = function(arr) {
		if (arr == "none") return;
		for (var i = 0; i <= arr.ubound(2); i++) {
			var tValue = {"dbPath":arr.getItem(1, i), "folder":arr.getItem(2, i)};
			this.plugin[arr.getItem(0, i)] = tValue;
		}
	}

  // Generate Security Code
  this.genSecurityCode = function(){
    if (getSession("SecurityCode") == undefined) {
      setSession("SecurityCode", randomStr(4, "0123456789"));
    } else {
      if (getSession("SecurityCode").length != 4) setSession("SecurityCode", randomStr(4, "0123456789"));
    }
  }

	// Save to cache
	this.saveToCache = function(strName, obj) {
		Application.Lock();
    Application(strName) = obj;
	  Application.Unlock();
	}

	// Clean all caches
	this.cleanAll = function() {
		Application.Contents.RemoveAll();
	}
}
%>
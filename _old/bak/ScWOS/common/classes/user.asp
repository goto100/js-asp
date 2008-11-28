<%
//////////////////////////////////////////////////
// Class Name: User
// Author: ScYui
// Last Modify: 2005/9/8
//////////////////////////////////////////////////
function User() {
	////////// Attributes //////////////////////////////
	// Private //////////
	var defaultLang = sys.setting.defaultLang;
	var defaultSkin = sys.setting.defaultSkin;
	var defaultStyle = sys.setting.defaultStyle;

	// Public //////////
	this.usingLang = getUsingLang();
	this.usingSkin = getUsingSkin();

	this.id = 0;
	this.email = "";
	this.password = "";
	this.secQuestion = "";
	this.secAnswer = "";
	this.firstName = "";
	this.lastName = "";
	this.gender = 0;
	this.zipcode = "";

	this.ip = getIP();
	this.loggedIn = false;

	this.group = {};	
	this.right = {};

	this.group.id = 1; // Default a guest

	////////// Methods //////////////////////////////
	// Private //////////

	// Get user language
	function getUsingLang() {
		if (getSiteCookie("language")) {
			return getSiteCookie("language");
		} else {
			return defaultLang;
		}
	}

	// Get user skin
	function getUsingSkin() {
		if (getSiteCookie("skin")) {
			return getSiteCookie("skin");
		} else {
			return defaultSkin;
		}
	}

	// Get user skin
	function getUsingStyle() {
		if (getSiteCookie("style")) {
			return getSiteCookie("style");
		} else {
			return defaultStyle;
		}
	}

	// Get IP
	function getIP() {
    var strIP = String(Request.ServerVariables("HTTP_X_FORWARDED_FOR")).replace(/[^0-9\.,]/g, "");
    if(strIP.length < 7) strIP = String(Request.ServerVariables("REMOTE_ADDR")).replace(/[^0-9\.,]/g, "");
    if(strIP.indexOf(",") > 7) strIP = strIP.substr(0, strIP.indexOf(","));
    return strIP;
	}

	// Fill user
	this.fill = function(value) {
		this.id = value["id"];
		this.email = value["email"];
		this.password = value["password"];
		this.nickname = value["nickname"];
		this.group.id = value["groupId"];
		this.group.name = value["name"];

		this.secQuestion = value["secQuestion"];
		this.secAnswer = value["secAnswer"];
		this.firstName = value["firstName"];
		this.lastName = value["lastName"];
		this.gender = value["gender"];
		this.zipcode = value["zipcode"];
	}

	// Check when visit
	this.checkCookie = function() {
		if (getSiteSession("userLoggedIn")) {
			this.login(getSiteSession("memberId"), getSiteSession("memberPassword"));
		} else if (getSiteCookie("remState")) {
			this.login(getSiteCookie("memberId"), getSiteCookie("memberPassword"));
		} else {
			this.logout();
		}
	}

	// Login
	this.login = function(memberId, codedPassword) {
		var tmpA = sys.conn.query("SELECT TOP 1 m.id, m.email, m.password, m.nickname, m.groupId, g.name"
			+ " FROM [Members] AS m, [UserGroups] AS g"
			+ " WHERE m.id = " + memberId
			+ " AND m.groupId = g.id");
		if (tmpA != null && codedPassword == tmpA["password"]) {
			setSiteSession("userLoggedIn", true);
			setSiteSession("memberId", tmpA["id"]);
			setSiteSession("memberPassword", tmpA["password"]);
			this.loggedIn = true;
			this.fill(tmpA);
		} else {
			this.logout();
		}
	}

	// Logout
	this.logout = function() {
    this.loggedIn=false;
		removeSiteSession("userLoggedIn");
		removeSiteSession("memberId");
		removeSiteSession("memberPassword");
		removeSiteCookie("remState");
		removeSiteCookie("memberId");
		removeSiteCookie("memberPassword");
	}

	this.edit = function(id) {
		var dbForm = this.fillForm();
		return dbForm;
	}

	this.fillForm = function() {
		var dbForm = new DBForm();
		dbForm.mode = "edit";
	
		dbForm.addItem("sign", "id", "number", true);
		var password = dbForm.addItem(false, "password", "string");
		password.setMinLength(sys.setting.memberPasswordMinLength, lang["password_short"]);
		password.setMaxLength(sys.setting.memberPasswordMaxLength, lang["password_long"]);
		var nickname = dbForm.addItem(true, "nickname", "string", true, lang["nickname_must"]);
		nickname.setMinLength(sys.setting.memberNicknameMinLength, lang["nickname_short"]);
		nickname.setMaxLength(sys.setting.memberNicknameMaxLength, lang["nickname_long"]);
		var groupId = dbForm.addItem(true, "groupId", "number", true);
		var tmpA = sys.conn.query("SELECT id AS [value], name AS title FROM [UserGroups]");
		groupId.setValues(tmpA, lang["userGroup_wrong"]);
		dbForm.addItem(true, "firstName", "string");
		dbForm.addItem(true, "lastName", "string");
		var gender = dbForm.addItem(true, "gender", "number");
		gender.setValues([{"value":0, "title":lang["gender_secret"]}, {"value":1, "title":lang["gender_female"]}, {"value":2, "title":lang["gender_male"]}], lang["gender_wrong"]);
		var secQuestion = dbForm.addItem(true, "secQuestion", "string", true, lang["sec_question_must"]);
		secQuestion.setMinLength(sys.setting.memberSecQuestionMinLength, lang["sec_question_short"]);
		secQuestion.setMaxLength(sys.setting.memberSecQuestionMaxLength, lang["sec_question_long"]);
		var secAnswer = dbForm.addItem(true, "secAnswer", "string", true, lang["sec_answer_must"]);
		secAnswer.setMinLength(sys.setting.memberSecAnswerMinLength, lang["sec_answer_short"]);
		secAnswer.setMaxLength(sys.setting.memberSecAnswerMaxLength, lang["sec_answer_long"]);
	
		dbForm.conn = sys.conn;
		dbForm.table = "Members";
		if (input.password) dbForm.addSubmit("password", code(input.password));
	
		return dbForm;
	}
}
%>

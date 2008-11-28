<%
// For IIS5.0
Array.prototype.push = function(value) {
	this[this.length] = value;
}

// Return object's expando names
Object.prototype.getExpandoNames = function() {
	var values = [];
	var obj = new this.constructor();
	for (var i in this) {
		if (obj[i] != this[i]) {
			values.push(i);
		}
	}
	delete obj;
	return values;
}

// Replace all once
String.prototype.replaceAll = function(strFind, strReplace) {
	var tStr = this;
	while (tStr.indexOf(strFind) != -1) {
		tStr = tStr.replace(strFind, strReplace);
	}
	return tStr;
}

// Check SQL
String.prototype.checkSQL = function() {
	return this.replace(/\'/ig, "''");
}

// DateTime Output function
Date.prototype.format = function(format) {
	if (!format)	format = "YY-MM-DD HH:II:SS";

	var tYear = this.getFullYear();
	var tMonth = this.getMonth() + 1;
	var tDate = this.getDate();
	var tDay = this.getDay();
	var tHour = this.getHours();
	var tHour12 = tHour > 12 ? tHour - 12 : tHour;
	var tMinute = this.getMinutes();
	var tSecond = this.getSeconds();
	var tAMPM = tHour > 12 ? "PM" : "AM";

	// Year
	format = format.replace(/([^\\]|^)YY/g, "$1" + tYear);
	format = format.replace(/([^\\]|^)yy/g, "$1" + tYear.toString().slice(-2));
	// Month
	format = format.replace(/([^\\]|^)MM/g, "$1" + (tMonth < 10? "0" : "") + tMonth);
	format = format.replace(/([^\\]|^)mm/g, "$1" + tMonth);
	// Date
	format = format.replace(/([^\\]|^)DD/g, "$1" + (tDate < 10? "0" : "") + tDate);
	format = format.replace(/([^\\]|^)dd/g, "$1" + tDate);
	// Hour
	format = format.replace(/([^\\]|^)HH/g, "$1" + (tHour < 10? "0" : "") + tHour);
	format = format.replace(/([^\\]|^)hh/g, "$1" + tHour);
	format = format.replace(/([^\\]|^)H/g, "$1" + (tHour12 < 10? "0" + tHour12 : tHour12));
	format = format.replace(/([^\\]|^)h/g, "$1" + tHour12);
	// Minute
	format = format.replace(/([^\\]|^)II/g, "$1" + (tMinute < 10? "0" : "") + tMinute);
	format = format.replace(/([^\\]|^)ii/g, "$1" + tMinute);
	// Second
	format = format.replace(/([^\\]|^)SS/g, "$1" + (tSecond < 10? "0" : "") + tSecond);
	format = format.replace(/([^\\]|^)ss/g, "$1" + tSecond);
	// AM PM
	format = format.replace(/([^\\]|^)A/g, "$1" + tAMPM);
	format = format.replace(/([^\\]|^)a/g, "$1" + tAMPM.toLowerCase());

	return format;
}

// Simple write
function write(strContent) {
	Response.Write(strContent);
}

// Write error msg on system hate on
function outputErrorMsg(err) {
	if (DEBUGMODE) {
		if (err.constructor == Error) {
			write(String(err.number & 0xFFFF)
				+ "<br/>"
				+ err.name
				+ "<br/>"
				+ err.description + "<br/>"
				+ err.message
				)
		} else {
			write(err);
		}
	} else {
		if (err.constructor == Error) {
			write("Unkown ERROR");
		} else {
			write(err);
		}
	}
	Response.End();
}
%>
<!-- #include file = "md5.asp" -->
<%
// Encode
function code(str) {
	return MD5(str);
}

// Get cilent IP
function getIP() {
	var ip = String(Request.ServerVariables("HTTP_X_FORWARDED_FOR")).replace(/[^0-9\.,]/g, "");
	if (ip.length < 7) ip = String(Request.ServerVariables("REMOTE_ADDR")).replace(/[^0-9\.,]/g, "");
	if (ip.indexOf(",") > 7) ip = ip.substr(0, ip.indexOf(","));
	return ip;
}

// Transform to boolean type
function transformBool(obj) {
	if (obj) return true;
	else return false;
}

// Add site's space name
function getSiteName(str) {
	return "wos" + NAMESPACE + str;
}

// Random string
function random(length, seed) {
	if (!seed) seed = "abcdefghijklmnopqrstuvwxyz1234567890";
	var result = "";
	for(var i = 0; i < length;){
		var pos = Math.round((Math.random() * seed.length));
		if(pos >= 0 && pos < seed.length){
			result += seed.charAt(pos);
			i++;
		}
	}
	return result;
}

// Transform absolute path
function transformPathToAbsolute(path) {
	if (path.substr(0, 1) != "/") {
		var pathInfoArr = String(Request.ServerVariables("PATH_INFO")).substr(1).split("/").slice(0, PATHDEPTH);
		path = path.substr(0, path.lastIndexOf("/"));
		var result = "";
		var pathArr = path.split("/");
		for (var i = 0; i < PATHDEPTH; i++) {
			if (pathArr[0] == "..") {
				pathInfoArr.pop();
				pathArr.shift();
			}
		}
		for (var i = 0; i < pathInfoArr.length; i++) {
			result += pathInfoArr[i] + "/";
		}
		for (var i = 0; i < pathArr.length; i++) {
			if (pathArr[i]) result += pathArr[i] + "/";
		}
		return result.slice(0, -1);
	} else {
		return path.slice(1, path.lastIndexOf("/"));
	}
}

// Transform path
function transformPath(pathA, pathB) {
	if (!pathB) pathB = "";
	var pathBName = pathB.substr(pathB.lastIndexOf("/") + 1);
	pathA = transformPathToAbsolute(pathA);
	pathB = transformPathToAbsolute(pathB);
	var result = "";
	var arrB = pathB.split("/");
	var arrA = pathA.split("/");
	var l = arrA.length;
	for (var i = 0; i < arrA.length; i++) {
		if (arrA[i] != arrB[i]) {
			l = i;
			i = arrA.length;
		}
	}
	for (var i = 0; i < arrA.length - l; i++) {
		if (arrA[i]) result += "../";
	}
	for (var i = l; i < arrB.length; i++) {
		if (arrB[i]) result += arrB[i] + "/";
	}

	return result + pathBName;
}

// Add to application
function addSiteApplication(strName, obj) {
	Application(getSiteName(strName)) = obj;
}

// Remove from application
function removeSiteApplication(strName) {
	Application.Contents.Remove(getSiteName(strName));
}

// Get application
function getSiteApplication(strName) {
	return Application(getSiteName(strName));
}

// Add to session
function setSiteSession(strName, obj) {
}

// Remove from session
function removeSiteSession(strName) {
	Session.Contents.Remove(getSiteName(strName));
}

// Get session
function getSiteSession(strName) {
	return Session(getSiteName(strName));
}

// Add to cookie
function setSiteCookie(name, value, expiresDate) {
	Response.Cookies(getSiteName(name)) = value;
	if (expiresDate) Response.Cookies(getSiteName(name)).Expires = expiresDate.getVarDate();
}

// Remove from cookie
function removeSiteCookie(strName) {
	Response.Cookies(getSiteName(strName)) = undefined;
}

// Get cookie
function getSiteCookie(strName) {
	return String(Request.Cookies(getSiteName(strName)));
}
%>

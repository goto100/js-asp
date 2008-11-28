<%@LANGUAGE="JAVASCRIPT" CODEPAGE="65001"%>
<%
Response.Buffer = true;
Session.Timeout = 20;
Session.CodePage = 65001;
var inWOS = true;

%>
<!-- #include file = "common/cls_scwos.asp" -->
<%
var theSite = new ScWOS();
with(theSite) {
	// Main DB path
	siteDBPath = "/../database/wos.mdb";

	// Set theSite.nameSpace
	// If you have more than one WOS in one server, you have to set diffirent name space
	nameSpace = "wos";

	// Define is debug mode
	debugMode = true;

	load();
}

function getLang(key) {
	return lang[key];
}

%>
<!-- #include file = "common/function.asp" -->
<%
// Get all request
var query = theSite.getQuery();
var input = theSite.getInput();

// Create cache
var theCache = theSite.cache;

if (query["cache"] == "clean") theCache.cleanAll();
theCache.load();

// Create a language object
var lang = theSite.getLanguageArray();

if (!theCache.setting.siteOpened) {
	var url = String(Request.ServerVariables("URL"));
	if ((url.indexOf("login.asp") == -1) && (url.indexOf("/admin/") == -1)) {
		write(theCache.setting.siteCloseDesc);
		Response.End();
	}
}

var theUser = theSite.checkCookies();
theUser.getUserRight();

// Default out method
function write(str) {
	Response.Write(str);
}

// Output Error Message
function outputErrorMsg(err) {
  if (err.constructor == Error) {
    write("Error number " + String(err.number & 0xFFFF) + "<br />" + err.description + "<br />" + err);
  } else {
    write(err);
  }
	Response.End();
}
%>

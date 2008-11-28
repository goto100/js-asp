<%@LANGUAGE="JAVASCRIPT" CODEPAGE="65001"%>
<!--#include file="controller/Action.asp" -->
<!--#include file="controller/Controller.asp" -->
<!--#include file="controller/SubmitAction.asp" -->
<!--#include file="controller/FormAction.asp" -->
<!--#include file="controller/ListAction.asp" -->
<!--#include file="database/DBAccess.asp" -->
<!--#include file="encoder/sha1.asp" -->
<!--#include file="lang/IOException.asp" -->
<!--#include file="model/CacheBase.asp" -->
<!--#include file="model/Category.asp" -->
<!--#include file="lang/List.asp" -->
<!--#include file="model/Right.asp" -->
<!--#include file="model/System.asp" -->
<!--#include file="view/FormView.asp" -->
<!--#include file="view/ListView.asp" -->
<!--#include file="view/View.asp" -->
<!--#include file="view/ViewElement.asp" -->
<!--#include file="view/RSSView.asp" -->
<%
// DateTime Output function
Date.prototype.format = function(format, timezone)
{
	if (!format)
		format = "yyyy-MM-dd HH:mm:ss";
	if (isNaN(timezone))
		timezone = - (this.getTimezoneOffset() / 60) * 100;

	this.setMinutes(this.getMinutes() + timezone * 0.6);

	var tYear = this.getUTCFullYear();
	var tMonth = this.getUTCMonth() + 1;
	var tDate = this.getUTCDate();
	var tHour = this.getUTCHours();
	var tHour12 = tHour > 12 ? tHour - 12 : tHour;
	var tMinute = this.getUTCMinutes();
	var tSecond = this.getUTCSeconds();

	// Year
	format = format.replace(/([^\\]|^)yyyy/g, "$1" + tYear);
	format = format.replace(/([^\\]|^)yy/g, "$1" + tYear.toString().slice(-2));
	// Month
	format = format.replace(/([^\\]|^)MM/g, "$1" + (tMonth < 10? "0" : "") + tMonth);
	format = format.replace(/([^\\]|^)M/g, "$1" + tMonth);
	// Date
	format = format.replace(/([^\\]|^)dd/g, "$1" + (tDate < 10? "0" : "") + tDate);
	format = format.replace(/([^\\]|^)d/g, "$1" + tDate);
	// Hour
	format = format.replace(/([^\\]|^)HH/g, "$1" + (tHour < 10? "0" : "") + tHour);
	format = format.replace(/([^\\]|^)hh/g, "$1" + tHour);
	format = format.replace(/([^\\]|^)H/g, "$1" + (tHour12 < 10? "0" + tHour12 : tHour12));
	format = format.replace(/([^\\]|^)h/g, "$1" + tHour12);
	// Minute
	format = format.replace(/([^\\]|^)mm/g, "$1" + (tMinute < 10? "0" : "") + tMinute);
	// Second
	format = format.replace(/([^\\]|^)ss/g, "$1" + (tSecond < 10? "0" : "") + tSecond);

	this.setMinutes(this.getMinutes() - timezone * 0.6);

	return format;
}

// Create date from a GMT date
Date.fromGMT = function(gmtDate)
{
	var date = new Date(gmtDate);

	date.setMinutes(date.getMinutes() - date.getTimezoneOffset());

	return date;
}

// Random string
String.random = function(length, seed)
{
	if (!seed) seed = "abcdefghijklmnopqrstuvwxyz1234567890";

	for (var i = 0, result = "", pos; i < length;) {
		pos = Math.round((Math.random() * seed.length));
		if (pos >= 0 && pos < seed.length){
			result += seed.charAt(pos);
			i++;
		}
	}

	return result;
}

// Simple write
function write(content)
{
	Response.Write(content);
}

// Simple write
function writeln(content)
{
	Response.Write(content + "<br />");
}

function test()
{
	write("!")
}

function XMLDom(aysnc)
{
	try
	{
		var xmlDom = new ActiveXObject("MSXML2.DomDocument");
	}
	catch(e)
	{
		try
		{
			var xmlDom = new ActiveXObject("MSXML.DomDocument");
		}
		catch(e)
		{
			try
			{
				var xmlDom = new ActiveXObject("Microsoft.XMLDom");
			}
			catch(e)
			{
				throw new Error(0, "Can't create XML Dom, you need Microsoft.XMLDom object.");
			}
		}
	}
	xmlDom.async = aysnc? true : false;

	return xmlDom;
}

/*

	// Return object's expando names
	Object.prototype.getExpandoNames = function()
	{
		var obj = new this.constructor();
		var names = [];
	
		for (var i in this) if ((obj[i] != this[i]) || (typeof obj[i] != typeof this[i])) names.push(i);
		delete obj;
	
		return names;
	}

	// Transform path to absolute
	function transformToAbsolutePath(path) {
		if (path.substr(0, 1) == "/") return path.substr(0, path.lastIndexOf("/"));

		var pathInfoArr = String(Request.ServerVariables("PATH_INFO")).substr(1).split("/").slice(0, PATH_DEPTH);
		path = path.substr(0, path.lastIndexOf("/"));
		var result = "";
		var pathArr = path.split("/");
		for (var i = 0; i < PATH_DEPTH; i++) if (pathArr[0] == "..") {
			pathInfoArr.pop();
			pathArr.shift();
		}
		for (var i = 0; i < pathInfoArr.length; i++) result += pathInfoArr[i] + "/";
		for (var i = 0; i < pathArr.length; i++) if (pathArr[i]) result += pathArr[i] + "/";

		return result.slice(0, -1);
	}

	// Get path
	function getPath(pathInfo, depth) {
		var pathDepth = pathInfo.match(/\//gi).length - 1 - depth;
		var path = pathInfo.substring(0, pathInfo.lastIndexOf("/"));
		var result = "", right = "";
		for (var i = 0; i < pathDepth; i++) {
			right = path.substring(path.lastIndexOf("/"));
			path = path.substring(0, path.lastIndexOf("/"));
			result = right + result;
		}
		result = result.slice(1) + "/";
		return result == "/"? "" : result;
	}
' Get VB Array to Application record online users
function vbs_getOnlineUsers(onlineUsers, userId)
	if (isEmpty(onlineUsers)) then
		redim onlineUsers(3, 0)
		onlineUsers(0, 0) = Session.SessionID
		onlineUsers(1, 0) = Request.ServerVariables("REMOTE_ADDR")
		onlineUsers(2, 0) = Now()
		onlineUsers(3, 0) = userId
	else
		dim i, has
		has = false
		for i = 0 to ubound(onlineUsers, 2)
			if DateDiff("s", onlineUsers(2, i), Now) > 600 then

			end if
			if onlineUsers(0, i) = Session.SessionID then
				onlineUsers(3, i) = userId
				has = true
				exit for
			end if
		next
		if not has then
			redim preserve onlineUsers(3, ubound(onlineUsers, 2) + 1)
			onlineUsers(0, ubound(onlineUsers, 2)) = Session.SessionID
			onlineUsers(1, ubound(onlineUsers, 2)) = Request.ServerVariables("REMOTE_ADDR")
			onlineUsers(2, ubound(onlineUsers, 2)) = Now()
			onlineUsers(3, ubound(onlineUsers, 2)) = userId
		end if
	end if
	vbs_getOnlineUsers = onlineUsers
end function
*/
%>
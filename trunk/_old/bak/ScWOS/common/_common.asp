<%@LANGUAGE="JAVASCRIPT" CODEPAGE="65001"%>
<%
Response.Buffer = true;
Session.Timeout = 20;
Session.CodePage = 65001;

// Golbal //////////////////////////////
var DEBUGMODE = true;
var NAMESPACE = "wos";
var PATHDEPTH = 1;
%>
<!-- #include file = "functions.asp" -->
<!-- #include file = "classes/xmldom.asp" -->
<!-- #include file = "classes/page.asp" -->
<!-- #include file = "classes/user.asp" -->
<!-- #include file = "classes/syswt.asp" -->
<%
var sys = new SysWT();
sys.dbPath = Server.MapPath("/../database/scwos.mdb");
sys.load();

var user = new User();
user.checkCookie();

var page = new Page();
page.load();

// Simple Variable
// Get all request
var search = page.search;
var input = page.input;
var lang = page.getLangs();
%>
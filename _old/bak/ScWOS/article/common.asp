<!-- #include file = "../common/_common.asp" -->
<%
var artiConn = new DBConn(Server.MapPath("/../database/sc_article.mdb"));
artiConn.open();

var lang = page.getLangs();
%>
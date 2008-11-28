<!-- #include file = "common.asp" -->
<!-- #include file = "../common/classes/category.asp" -->
<%
var category = new Category(conn, page, search, input);
category.run();
%>
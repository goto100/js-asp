<!-- #include file = "../common.asp" -->
<!-- #include file = "../../common/classes/category.asp" -->
<%
var category = new Category(artiConn, page, search, input, true);
category.run();
%>
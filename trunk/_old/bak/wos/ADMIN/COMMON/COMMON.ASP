<!-- #include file = "../../common/common.asp" -->
<!-- #include file = "../../skins/default/langs/en/admin.asp" -->
<%
getAdminLanguageArray(lang);
%>
<!-- #include file = "../../skins/default/templates/admin.asp" -->
<%
if (!theUser.right.manage) thePage.outputAlert([getLang("no_right_desc")]);
%>

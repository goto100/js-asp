<!-- #include file = "../../common/common.asp" -->
<!-- #include file = "../../../../langs/zh-cn/admin.asp" -->
<%
getAdminLanguageArray(lang);
%>
<!-- #include file = "../../../../skins/default/templates/admin.asp" -->
<%
if (!theUser.right.manage) thePage.outputAlert([getLang("no_right_desc")]);
thePage.addPanel(getLang("news_system_manage"),
	[	"<a href=\"admin.asp\">" + getLang("general_infomation") + "</a>"
	, "<a href=\"setting.asp\">" + getLang("general_setting") + "</a>"
	, "<a href=\"category.asp\">" + getLang("category_manage") + "</a>"
	, "<a href=\"userright.asp\">" + getLang("user_right") + "</a>"
	]
								);
%>
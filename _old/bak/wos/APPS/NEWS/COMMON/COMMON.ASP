<!-- #include file = "../../../_common.asp" -->
<!-- #include file = "../../../skins/default/langs/en/news.asp" -->
<!-- #include file = "cls_news.asp" -->
<%
getNewsLanguageArray(lang);
var appNews = new PlugNews(theCache.plugin.news.dbPath, "appNews");

// if (!Application(theSite.nameSpace + "InPlugin") || Application(theSite.nameSpace + "InPlugin") != "news") {
	// theCache.saveToCache(theSite.nameSpace + "InPlugin", "news");
	theCache.userGroups = appNews.loadUserGroups(theCache.userGroups);
// }
theSite.plugin = "news";
%>
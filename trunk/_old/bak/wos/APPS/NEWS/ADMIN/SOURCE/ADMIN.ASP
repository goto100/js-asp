<%
var info = {"version":appNews.version
					, "pluginPath":(Request.ServerVariables("APPL_PHYSICAL_PATH") + theCache.setting.sitePath + theCache.plugin.news.folder).replace("\\/", "\\").replace("\/", "\\").slice(0, -1)
					};
outputAdmin(info);
%>
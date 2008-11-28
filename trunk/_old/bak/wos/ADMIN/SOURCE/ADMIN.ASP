<%
switch(query["act"]) {
	case "opensite":
		theSite.open();
		Response.Redirect("admin.asp");
		break;

	case "closesite":
		theSite.close();
		Response.Redirect("admin.asp");
		break;

	default:
		var info = {"serverSoftware":Request.ServerVariables("SERVER_SOFTWARE")
							, "serverTime":getDateTimeString("YY-MM-DD hh:ii:ss Z")
							, "serverIP":Request.ServerVariables("LOCAL_ADDR")
							, "applicationPath":(Request.ServerVariables("APPL_PHYSICAL_PATH") + theCache.setting.sitePath).replace("\\/", "\\").slice(0, -1)
							, "scriptEngine":ScriptEngineMajorVersion() + "." + ScriptEngineMinorVersion() + "." + ScriptEngineBuildVersion()
							, "fsoSuppose":checkServerObject("Scripting.FileSystemObject")
							, "xmlHttpSuppose":checkServerObject("MSXML2.ServerXMLHTTP")
							, "xmlDomSuppose":checkServerObject("Microsoft.XMLDOM")
							, "streamSuppose":checkServerObject("ADODB.Stream")
							};
		outputAdmin(info);
}
%>
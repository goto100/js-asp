<script language="vbscript" runat="server">
dim vbs_crlf : vbs_crlf = chrB(13) & chrB(10)
function vbs_inStrB(p1, p2, p3, p4)
	vbs_inStrB = InStrB(p1, p2, p3, p4)
end function
function vbs_midB(p1, p2, p3)
	vbs_midB = MidB(p1, p2, p3)
end function
function vbs_lenB(param)
	vbs_lenB = LenB(param)
end function
</script>
<script language="javascript" runat="server">
function HttpRequest() {
	var userAgent = String(Request.ServerVariables("HTTP_USER_AGENT")).toLowerCase();

	this.search = getSearch();
	this.input = getInput();
	this.path = String(Request.ServerVariables("PATH_INFO"));
	this.referer = getReferer();
	this.ip = getIP();
	this.os = getOS();
	this.browser = getBrowser();

	// Request.Form
	function getInput() {
		var i, input = {}
		if (String(Request.ServerVariables("CONTENT_TYPE")).substr(0, 19) == "multipart/form-data") {
			input = getDataInput();
		} else {
			var name;
			var e = new Enumerator(Request.Form);
			for (i = 0; !e.atEnd(); e.moveNext(), i++) {
				name = String(e.item());
				input[name] = String(Request.Form(name));
			}
		}
		return input;
	}

	// Request with multipart/form-data
	function getDataInput() {
		if (Request.TotalBytes < 1) return false;
		var charset = String(Request.ServerVariables("HTTP_ACCEPT_CHARSET"));
		charset = charset.substr(0, charset.indexOf(","));
		if (!charset) charset = "UTF-8";
		var input = {}
		var dataStream = new ActiveXObject("ADODB.Stream");
		dataStream.Type = 1;
		dataStream.Mode = 3;
		dataStream.Open();
		dataStream.Write(Request.BinaryRead(Request.TotalBytes));
		dataStream.Position = 0;
		var requestData = dataStream.Read();
		var formStart = 1;
		var formEnd = vbs_lenB(requestData);

		// Get separator's length
		var separator = vbs_midB(requestData, 1, vbs_inStrB(1, requestData, vbs_crlf, 0) - 1); // First line
		var separatorLength = vbs_lenB(separator);

		formStart += separatorLength + 1; // Begin at next line, start to get informations!
		var infoEnd = 0;
		var stream = new ActiveXObject("ADODB.Stream");
		while (formStart + 10 < formEnd) {
			// Get form name
			infoEnd = vbs_inStrB(formStart, requestData, vbs_crlf + vbs_crlf, 0) + 3;
			stream.Type = 1;
			stream.Mode = 3;
			stream.Open();
			dataStream.Position = formStart;
			dataStream.CopyTo(stream, infoEnd - formStart);
			stream.Position = 0;
			stream.Type = 2;
			stream.Charset = charset;
			var info = stream.ReadText();
			stream.Close();
			formStart = vbs_inStrB(infoEnd, requestData, separator, 0);
			var findStart = info.indexOf("name=\"", 22) + 6;
			var findEnd = info.indexOf("\"", findStart);
			var formName = info.substr(findStart, findEnd - findStart);
			if (info.indexOf("filename=\"", 41) > 0) { // A file
				var file = new UploaderFile();
				file.setStreamSource(dataStream, infoEnd);
				findStart = info.indexOf("filename=\"", findEnd) + 10;
				findEnd = info.indexOf("\"", findStart);
				file.name = info.substr(findStart, findEnd - findStart); // Name
				findStart = info.indexOf("Content-Type: ", findEnd) + 14;
				findEnd = info.indexOf("\r", findStart);
				file.contentType = info.substr(findStart, findEnd - findStart); // Content type
				file.size = formStart - infoEnd - 3; // Size
				if (file.name) {
					if (!input[formName]) input[formName] = [];
					input[formName].push(file);
				}
			} else { // A form item
				stream.Type = 1;
				stream.Mode = 3;
				stream.Open();
				dataStream.Position = infoEnd; 
				dataStream.CopyTo(stream, formStart - infoEnd - 3);
				stream.Position = 0;
				stream.Type = 2;
				stream.Charset = charset;
				var formValue = stream.ReadText();
				stream.Close();
				if (!input[formName]) input[formName] = formValue;
				else input[formName] += ", " + formValue;
			}
			formStart = formStart + separatorLength + 1;
		}
		delete requestData;
		delete stream;
		return input;
	}

	// Request.QueryString
	function getSearch() {
		var i, j, e, item, names, search;
		e = new Enumerator(Request.QueryString);
		for (i = 0, names = [], search = {}; !e.atEnd(); e.moveNext()) {
			item = e.item();
			names = String(item).split("&");
			search[names[names.length - 1]] = String(Request.QueryString(item));
			if (names.length > 1) for (j = 0; j < names.length - 1; j++) {
				search[i++] = names[j];
				search[names[j]] = null;
			}
			search[i++] = names[names.length - 1];
		}
		return search;
	}

	// Referer
	function getReferer() {
		var referer = String(Request.ServerVariables("HTTP_REFERER"));
		return referer == "undefined"? null : referer;
	}

	// IP Address
	function getIP() {
		var ip = String(Request.ServerVariables("HTTP_X_FORWARDED_FOR")).replace(/[^0-9\.,]/g, "");
		if (ip.length < 7) ip = String(Request.ServerVariables("REMOTE_ADDR")).replace(/[^0-9\.,]/g, "");
		if (ip.indexOf(",") > 7) ip = ip.substr(0, ip.indexOf(","));
		return ip;
	}

	// OS
	function getOS() {
		if (userAgent.indexOf("windows ce") > -1) return "Windows CE";
		if (userAgent.indexOf("windows 95") > -1) return "Windows 95";
		if (userAgent.indexOf("win98") > -1) return "Windows 98";
		if (userAgent.indexOf("windows 98") > -1) return "Windows 98";
		if (userAgent.indexOf("windows 2000") > -1) return "Windows 2000";
		if (userAgent.indexOf("windows xp") > -1) return "Windows XP";
		if (userAgent.indexOf("windows nt 5.0") > -1) return "Windows 2000";
		if (userAgent.indexOf("windows nt 5.1") > -1) return "Windows XP";
		if (userAgent.indexOf("windows nt 5.2") > -1) return "Windows 2003";
		if (userAgent.indexOf("windows nt") > -1) return "Windows NT";
		if (userAgent.indexOf("windows") > -1) return "Windows";

		if (userAgent.indexOf("x11") > -1 || userAgent.indexOf("unix") > -1) return "Unix";
		if (userAgent.indexOf("sunos") > -1 || userAgent.indexOf("sun os") > -1) return "SUN OS";
		if (userAgent.indexOf("powerpc") > -1 || userAgent.indexOf("ppc") > -1) return "PowerPC";
		if (userAgent.indexOf("macintosh") > -1) return "Mac";
		if (userAgent.indexOf("mac osx") > -1) return "MacOSX";
		if (userAgent.indexOf("freebsd") > -1) return "FreeBSD";
		if (userAgent.indexOf("linux") > -1) return "Linux";
		if (userAgent.indexOf("palmsource") > -1 || userAgent.indexOf("palmos") > -1) return "PalmOS";
		if (userAgent.indexOf("wap ") > -1) return "WAP";
		return "Unknown";
	}

	// Browser
	function getBrowser() {
		var browser = "";
		var type = "";

		if (userAgent.indexOf("mozilla") > -1) browser = "Mozilla";
		if (userAgent.indexOf("icab") > -1) browser = "iCab";
		if (userAgent.indexOf("lynx") > -1) browser = "Lynx";
		if (userAgent.indexOf("links") > -1) browser = "Links";
		if (userAgent.indexOf("elinks") > -1) browser = "ELinks";
		if (userAgent.indexOf("jbrowser") > -1) browser = "JBrowser";
		if (userAgent.indexOf("gecko") > -1) {
			browser = "Mozilla";
			type = "[Gecko]";
			if (userAgent.indexOf("aol") > -1) browser = "AOL";
			if (userAgent.indexOf("netscape") > -1) browser = "Netscape";
			if (userAgent.indexOf("firefox") > -1) browser = "FireFox";
			if (userAgent.indexOf("chimera") > -1) browser = "Chimera";
			if (userAgent.indexOf("camino") > -1) browser = "Camino";
			if (userAgent.indexOf("galeon") > -1) browser = "Galeon";
			if (userAgent.indexOf("k-meleon") > -1) browser = "K-Meleon";
		}

		if (userAgent.indexOf("konqueror") > -1) browser = "Konqueror";

		if (userAgent.indexOf("bot") > -1 || userAgent.indexOf("crawl") > -1) {
			browser = "";
			type = "[Bot/Crawler]";
			if (userAgent.indexOf("grub") > -1) browser = "Grub";
			if (userAgent.indexOf("googlebot") > -1) browser = "GoogleBot";
			if (userAgent.indexOf("msnbot") > -1) browser = "MSN Bot";
			if (userAgent.indexOf("slurp") > -1) browser = "Yahoo! Slurp";
		}

		if (userAgent.indexOf("wget") > -1) browser = "Wget";

		if (userAgent.indexOf("ask jeeves") > -1 || userAgent.indexOf("teoma") > -1) browser = "Ask Jeeves/Teoma";

		if (userAgent.indexOf("msie") > -1) {
			type = "[IE";
			var start = userAgent.indexOf("msie");
			var end = userAgent.indexOf(";", start);
			type += " " + userAgent.substr(start + 5, end - start - 5) + "]";
			browser = "IE";
			if (userAgent.indexOf("msn") > -1) browser = "MSN";
			if (userAgent.indexOf("aol") > -1) browser = "AOL";
			if (userAgent.indexOf("webtv") > -1) browser = "WebTV";
			if (userAgent.indexOf("myie2") > -1) browser = "MyIE2";
			if (userAgent.indexOf("maxthon") > -1) browser = "Maxthon";
			if (userAgent.indexOf("gosurf") > -1) browser = "GoSurf";
			if (userAgent.indexOf("netcaptor") > -1) browser = "NetCaptor";
			if (userAgent.indexOf("sleipnir") > -1) browser = "Sleipnir";
			if (userAgent.indexOf("avant browser") > -1) browser = "AvantBrowser";
			if (userAgent.indexOf("greenbrowser") > -1) browser = "GreenBrowser";
			if (userAgent.indexOf("slimbrowser") > -1) browser = "SlimBrowser";
		}

		if (userAgent.indexOf("opera") > -1) {
			var start = userAgent.indexOf("opera");
			browser = "Opera " + userAgent.substr(start + 6, start + 4);
		}

		if (userAgent.indexOf("applewebkit") > -1) {
			type = "[AppleWebKit]";
			browser = "";
			if (userAgent.indexOf("omniweb") > -1) browser = "OmniWeb";
			if (userAgent.indexOf("safari") > -1) browser = "Safari";
		}
		return browser += type;
	}
}
</script>
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
	this.search = getSearch();
	this.input = getInput();
	this.path = String(Request.ServerVariables("PATH_INFO"));
	this._ip;

	// Request.Form
	function getInput() {
		var input = {}
		if (String(Request.ServerVariables("CONTENT_TYPE")).substr(0, 19) == "multipart/form-data") {
			input = getDataInput();
		} else {
			var name;
			var e = new Enumerator(Request.Form);
			for (var i = 0; !e.atEnd(); e.moveNext(), i++) {
				name = String(e.item());
				input[i] = input[name] = String(Request.Form(name));
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
		var queryString = String(Request.QueryString);
		var path = queryString.substr(0, queryString.indexOf("?")).split("/");
		var search = queryString.substr(queryString.indexOf("?") + 1).split("&");
		search.unshift(path);
		for (var i = 1/* Ignore path */; i < search.length; i++) {
			search[i] = new String(search[i]);
			search[i].name = search[i].substr(0, search[i].indexOf("="));
			search[i].valueOf = function() {
				return this.substr(this.indexOf("=") + 1);
			}
			search[search[i].name] = search[i];
		}
		return search;
	}
}

HttpRequest.prototype.getIP = function() {
	if (this._ip) return this._ip;
	this._ip = String(Request.ServerVariables("HTTP_X_FORWARDED_FOR")).replace(/[^0-9\.,]/g, "");
	if (this._ip.length < 7) this._ip = String(Request.ServerVariables("REMOTE_ADDR")).replace(/[^0-9\.,]/g, "");
	if (this._ip.indexOf(",") > 7) this._ip = this._ip.substr(0, this._ip.indexOf(","));
	return this._ip;
}
</script>
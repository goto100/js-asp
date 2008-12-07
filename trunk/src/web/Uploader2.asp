<!--#include file="UploaderFile.asp" -->
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
function Uploader() {
	this.filePath = Server.MapPath("/js-asp/img/upload.xml");
	this.fso = Server.CreateObject("Scripting.FileSystemObject");
}

Uploader.prototype.getInput = function() {
	if (Request.TotalBytes < 1) return false;
	var charset = String(Request.ServerVariables("HTTP_ACCEPT_CHARSET"));
	// charset = charset.substr(0, charset.indexOf(","));
	charset = "UTF-8";
	var input = {}

	var dataStream = Server.CreateObject("ADODB.Stream");
	dataStream.Type = 1;
	dataStream.Mode = 3;
	dataStream.Open();
	var totalSize = Request.TotalBytes;
	var blockSize = Math.round(totalSize / 1000);
	if (blockSize < 65536) blockSize = 65536; // 64kB
	var readSize = 0;
	var data;
	this.outputProgress(readSize, totalSize);
	while(readSize < totalSize) {
		if (readSize + blockSize > totalSize) blockSize = totalSize - readSize;
		data = Request.BinaryRead(blockSize);
		readSize += blockSize;
		dataStream.Write(data);
		this.outputProgress(readSize, totalSize);
	}
	dataStream.Position = 0;
	var requestData = dataStream.Read();
	var formStart = 1;
	var formEnd = vbs_lenB(requestData);

	// Get separator's length
	var separator = vbs_midB(requestData, 1, vbs_inStrB(1, requestData, vbs_crlf, 0) - 1); // First line
	var separatorLength = vbs_lenB(separator);
	formStart += separatorLength + 1; // Begin at next line, start get data!
	var infoEnd = 0;
	var stream = Server.CreateObject("ADODB.Stream");
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

Uploader.prototype.outputProgress = function(readSize, totalSize) {
	var file = this.fso.CreateTextFile(this.filePath, true);
	file.WriteLine("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
	file.WriteLine("<upload read=\"" + readSize + "\" total=\"" + totalSize + "\" />");
	file.Close();
	if (readSize == totalSize && false) {
		if (this.fso.FileExists(this.filePath)) this.fso.DeleteFile(this.filePath);
		delete this.fso;
	}
}

</script>
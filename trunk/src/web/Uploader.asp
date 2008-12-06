<!--#include file="UploaderFile.asp" -->
<script language="javascript" runat="server">
/*
This is a request data
********************************************************************
-----------------------------196291262324084
Content-Disposition: form-data; name="file"; filename="file.txt"
Content-Type: text/plain

content
-----------------------------196291262324084
Content-Disposition: form-data; name="submit"

submit
-----------------------------196291262324084
Content-Disposition: form-data; name="text"

text
-----------------------------196291262324084--
********************************************************************
*/

function Uploader() {
	this.filePath = Server.MapPath("/js-asp/img/upload.xml");
	this.fso = Server.CreateObject("Scripting.FileSystemObject");
	this.dataStream = Server.CreateObject("ADODB.Stream");
	this.dataStream.Type = 1;
	this.dataStream.Mode = 3;
	this.tempStream = Server.CreateObject("ADODB.Stream");
	this.charset = String(Request.ServerVariables("HTTP_ACCEPT_CHARSET"));
	// this.charset = this.charset.substr(0, this.charset.indexOf(","));
	this.charset = "UTF-8";
	this.size = 0;
}

Uploader.prototype.getInput = function() {
	if (Request.TotalBytes < 1) return false;
	var input = {}

	;;; test.start();
	this.dataStream.Open();
	this.size = Request.TotalBytes;
	var blockSize = Math.round(this.size / 1000);
	if (blockSize < 65536) blockSize = 65536; // 64kB
	var readSize = 0;
	var block;
	this.outputProgress(readSize, this.size);
	while(readSize < this.size) {
		if (readSize + blockSize > this.size) blockSize = this.size - readSize;
		block = Request.BinaryRead(blockSize);
		readSize += blockSize;
		this.dataStream.Write(block);
		this.outputProgress(readSize, this.size);
	}
	this.dataStream.Position = 0;
	var data = this.dataStream.Read();


	separator = vbs_midB(data, 1, vbs_inStrB(1, data, vbs_crlf, 0) - 1); // First line
	separatorLength = vbs_lenB(separator);
	var start = 1;
	start += separatorLength + 1; // Begin at next line, start get data!

	var infoEnd = 0;
	while (start + 2 < this.size) {
		this.tempStream.Type = 1;
		this.tempStream.Mode = 3;
		this.tempStream.Open();
		infoEnd = vbs_inStrB(start, data, vbs_crlf + vbs_crlf, 0) + 3;
		this.dataStream.Position = start;
		this.dataStream.CopyTo(this.tempStream, infoEnd - start - 4); // 4 = \r\n * 2
		this.tempStream.Position = 0;
		this.tempStream.Type = 2;
		this.tempStream.Charset = this.charset;
		var info = this.tempStream.ReadText();
		this.tempStream.Close();
		start = vbs_inStrB(infoEnd, data, separator, 0);
		this.dataStream.Position = infoEnd;

		var item = this.getForm(info, start - infoEnd - 3);

		if (instanceOf(item.value, UploaderFile)) {
			if (!input[item.name]) input[item.name] = [];
			if (item.value.name) input[item.name].push(item.value);
			item.value.setStreamSource(this.dataStream, infoEnd);
		} else {
			if (!input[item.name]) input[item.name] = item.value;
			else input[item.name] += ", " + item.value;
		}
		start += separatorLength + 1;
	}
	delete data;
	delete this.tempStream;
	;;; test.end("Load Request: ");
	return input;

}

Uploader.prototype.getForm = function(info, size) {
	var item = {}
	info = new String(info);
	if (info.match(/ filename\=\"(.*?)\"/ig)) info.filename = RegExp.$1;
	if (info.match(/ name\=\"(.+?)\"/ig)) item.name = RegExp.$1;

	if (info.filename != undefined) { // A file
		var file = new UploaderFile();
		file.path = info.filename;
		file.name = file.path.substring(file.path.lastIndexOf("\\") + 1);
		if (info.match(/Content\-Type\: (.+?)$/ig)) file.contentType = RegExp.$1;
		file.size = size;
		item.value = file;
	} else { // A form item
		this.tempStream.Type = 1;
		this.tempStream.Mode = 3;
		this.tempStream.Open();
		this.dataStream.CopyTo(this.tempStream, size);
		this.tempStream.Position = 0;
		this.tempStream.Type = 2;
		this.tempStream.Charset = this.charset;
		item.value = this.tempStream.ReadText();
		this.tempStream.Close();
	}
	return item;
}

Uploader.prototype.outputProgress = function(readSize) {
	var file = this.fso.CreateTextFile(this.filePath, true);
	file.WriteLine("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
	file.WriteLine("<upload read=\"" + readSize + "\" total=\"" + this.size + "\" />");
	file.Close();
	if (readSize == this.size && false) {
		if (this.fso.FileExists(this.filePath)) this.fso.DeleteFile(this.filePath);
		delete this.fso;
	}
}
</script>
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

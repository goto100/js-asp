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

function Uploader2() {
	this.filePath = Server.MapPath("/js-asp/img/upload.xml");
	this.fso = Server.CreateObject("Scripting.FileSystemObject");
	this.dataStream = Server.CreateObject("ADODB.Stream");
	this.dataStream.Type = 1;
	this.dataStream.Mode = 3;
	this.charset = String(Request.ServerVariables("HTTP_ACCEPT_CHARSET"));
	// this.charset = this.charset.substr(0, this.charset.indexOf(","));
	this.charset = "UTF-8";
	this.size = 0;
	this.block = {size: {min: 1024, max: 65536}};
	this.outputs = {length: 0};
}

Uploader2.prototype.getInput = function() {
	if (Request.TotalBytes < 1) return false;
	var input = {}

	this.dataStream.Open();
	this.size = Request.TotalBytes;
	var separator;
	var separatorLength;
	var block = {size: Math.round(this.size / 1000)};
	if (block.size < this.block.size.min) block.size = this.block.size.min;
	if (block.size > this.block.size.max) block.size = this.block.size.max;
	var readBlock = {size: 1024, read: 0};
	var segment = {data: {start: 0, size: 0}, stream: this.dataStream};
	this.readSize = 0;
	this.outputProgress();
	var i = 0;

	while (this.readSize < this.size) {
		if (this.readSize + block.size > this.size) block.size = this.size - this.readSize;
		block.data = Request.BinaryRead(block.size);
		this.dataStream.Write(block.data);
		this.readSize += block.size;
		if (i == 0) {
			separator = vbs_midB(block.data, 1, vbs_inStrB(1, block.data, vbs_crlf, 0) - 1); // First line
			separatorLength = vbs_lenB(separator);
		}

		this.outputProgress();
		i++;
	}
	this.dataStream.Position = 0;
	var data = this.dataStream.Read();

	var start = 1;
	start += separatorLength + 1; // Begin at next line, start get data!

	var infoEnd = 0;
	while (start + 3 < this.size) {
		infoEnd = vbs_inStrB(start, data, vbs_crlf + vbs_crlf, 0) + 3;
		var info = Uploader2.binToString(this.dataStream, this.charset, start, infoEnd - start - 4);
		start = vbs_inStrB(infoEnd, data, separator, 0);

		var item = this.getForm(info, infoEnd, start - infoEnd - 3);

		if (instanceOf(item.value, Uploader2File)) {
			if (!input[item.name]) input[item.name] = [];
			if (item.value.name) input[item.name].push(item.value);
		} else {
			if (!input[item.name]) input[item.name] = item.value;
			else input[item.name] += ", " + item.value;
		}
		start += separatorLength + 1;
	}
	delete data;
	return input;
}

Uploader2.prototype.getForm = function(info, start, size) {
	var item = {}
	info = new String(info);
	if (info.match(/ filename\=\"(.*?)\"/ig)) info.filename = RegExp.$1;
	if (info.match(/ name\=\"(.+?)\"/ig)) item.name = RegExp.$1;

	this.dataStream.Position = start;
	if (info.filename != undefined) { // A file
		var file = new Uploader2File();
		file.path = info.filename;
		file.name = file.path.substring(file.path.lastIndexOf("\\") + 1);
		if (info.match(/Content\-Type\: (.+?)$/ig)) file.contentType = RegExp.$1;
		file.size = size;
		file.setStreamSource(this.dataStream, start);
		item.value = file;
	} else item.value = Uploader2.binToString(this.dataStream, this.charset, start, size);
	return item;
}

Uploader2.prototype.outputProgress = function() {
	var file = this.fso.CreateTextFile(this.filePath, true);
	file.WriteLine("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
	file.WriteLine("<upload read=\"" + this.readSize + "\" total=\"" + this.size + "\" count=\"" + this.outputs.length++ + "\" />");
	file.Close();
	if (this.readSize == this.size && false) {
		if (this.fso.FileExists(this.filePath)) this.fso.DeleteFile(this.filePath);
		delete this.fso;
	}
}

Uploader2.tempStream = null;

Uploader2.getBin = function(source, start, size) {
	if (!Uploader2.tempStream) Uploader2.tempStream = Server.CreateObject("ADODB.Stream");
	var stream = Uploader2.tempStream;
	stream.Type = 1;
	stream.Mode = 3;
	stream.Open();
	source.Position = start;
	source.CopyTo(stream, size);
	stream.Position = 0;
	var bin = stream.Read();
	stream.Close();
	return bin;
}

Uploader2.binToString = function(source, charset, start, size) {
	if (!Uploader2.tempStream) Uploader2.tempStream = Server.CreateObject("ADODB.Stream");
	var stream = Uploader2.tempStream;
	stream.Type = 1;
	stream.Mode = 3;
	stream.Open();
	source.Position = start;
	source.CopyTo(stream, size);
	stream.Position = 0;
	stream.Type = 2;
	stream.Charset = charset;
	var string = stream.ReadText();
	stream.Close();
	return string;
}

</script>

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
	this.charset = String(Request.ServerVariables("HTTP_ACCEPT_CHARSET"));
	// this.charset = this.charset.substr(0, this.charset.indexOf(","));
	this.charset = "UTF-8";
	this.size = 0;
	this.block = {size: {min: 1024, max: 65536}};
	this.outputs = {length: 0};
	this.input = {};
	this.boundary;
	this.boundaryLength;
	this.segments = [];
}

Uploader.prototype.getInput = function() {
	if (Request.TotalBytes < 1) return false;

	this.dataStream.Open();
	this.size = Request.TotalBytes;
	this.readSize = 0;
	var block = {size: Math.round(this.size / 1000)};
	if (block.size < this.block.size.min) block.size = this.block.size.min;
	if (block.size > this.block.size.max) block.size = this.block.size.max;
	var readBlock = {size: 1024, read: 0};
	var segment = {data: {start: 0, size: 0}, stream: this.dataStream};
	this.outputProgress();

	var i = 0;
	while (this.readSize < this.size) {
		if (this.readSize + block.size > this.size) block.size = this.size - this.readSize;
		block.data = Request.BinaryRead(block.size);
		this.dataStream.Write(block.data);
		this.readSize += block.size;
		if (i == 0) {
			this.boundary = vbs_midB(block.data, 1, vbs_inStrB(1, block.data, vbs_crlf, 0) - 1);
			this.boundaryLength = vbs_lenB(this.boundary);
		}
		readBlock.read += block.size;
		if (readBlock.read >= readBlock.size || this.readSize == this.size) {
			readBlock.data = Uploader.getBin(this.dataStream, this.readSize - readBlock.read, readBlock.size);

			var boundaryAt = vbs_inStrB(pos, readBlock.data, this.boundary, 0);
			if (boundaryAt == 0) {
				segment.data.size = readBlock.size;
			} else if (boundaryAt == 1) {
				infoEnd = vbs_inStrB(pos, readBlock.data, vbs_crlf + vbs_crlf, 0);
				pos = this.boundaryLength + 2;
				segment.info = Uploader.binToString(this.dataStream, this.charset, pos, infoEnd - pos - 1);
				segment.data.start = infoEnd + this.boundaryLength + 1;
				segment.data.size = readBlock.size;
			} else {
				segment.data.size += boundaryAt;
				this.segments.push(segment);
				segment = {data: {start: 0, size: 0}, stream: this.dataStream};
				pos = boundaryAt + 3;
			}

			readBlock.read = 0;
		}

		this.outputProgress();
		i++;
	}

	for (var i = 0; i < this.segments.length; i++) {
		var item = this.getForm(this.segments[i].info, this.segments[i].start, this.segments[i].size);
		writeln(this.segments[i].info);
		writeln(this.segments[i].data.start + " has " + this.segments[i].data.size)
		this.fillInput(item);
	}

	return this.input;
}

Uploader.prototype.fillInput = function(item) {
	if (instanceOf(item.value, UploaderFile)) {
		if (!this.input[item.name]) this.input[item.name] = [];
		if (item.value.name) this.input[item.name].push(item.value);
	} else {
		if (!this.input[item.name]) this.input[item.name] = item.value;
		else this.input[item.name] += ", " + item.value;
	}
}

Uploader.prototype.getForm = function(info, start, size) {
	var item = {}
	info = new String(info);
	if (info.match(/ filename\=\"(.*?)\"/ig)) info.filename = RegExp.$1;
	if (info.match(/ name\=\"(.+?)\"/ig)) item.name = RegExp.$1;

	this.dataStream.Position = start;
	if (info.filename != undefined) { // A file
		var file = new UploaderFile();
		file.path = info.filename;
		file.name = file.path.substring(file.path.lastIndexOf("\\") + 1);
		if (info.match(/Content\-Type\: (.+?)$/ig)) file.contentType = RegExp.$1;
		file.size = size;
		file.setStreamSource(this.dataStream, start);
		item.value = file;
	} else item.value = Uploader.binToString(this.dataStream, this.charset, start, size);
	return item;
}

Uploader.prototype.outputProgress = function() {
	var file = this.fso.CreateTextFile(this.filePath, true);
	file.WriteLine("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
	file.WriteLine("<upload read=\"" + this.readSize + "\" total=\"" + this.size + "\" count=\"" + this.outputs.length++ + "\" />");
	file.Close();
	if (this.readSize == this.size && false) {
		if (this.fso.FileExists(this.filePath)) this.fso.DeleteFile(this.filePath);
		delete this.fso;
	}
}

Uploader.tempStream = null;

Uploader.getBin = function(source, start, size) {
	if (!Uploader.tempStream) Uploader.tempStream = Server.CreateObject("ADODB.Stream");
	var stream = Uploader.tempStream;
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

Uploader.binToString = function(source, charset, start, size) {
	if (!Uploader.tempStream) Uploader.tempStream = Server.CreateObject("ADODB.Stream");
	var stream = Uploader.tempStream;
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

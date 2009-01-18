<!--#include file="UploaderFile.asp" -->
<script language="javascript" runat="server">
function Uploader() {
	this.filePath = Server.MapPath(UPLOAD_PATH) + "/.upload.xml";
	this.fso = Server.CreateObject("Scripting.FileSystemObject");
	this.stream = Server.CreateObject("ADODB.Stream");
	this.stream.Type = 1;
	this.stream.Open();
	this.separator;
	this.separatorLength;
	this.charset = String(Request.ServerVariables("HTTP_ACCEPT_CHARSET"));
	// this.charset = this.charset.substr(0, this.charset.indexOf(","));
	this.charset = "UTF-8";
	this.size = Request.TotalBytes;
	this.readSize = 0;
	this.blockSize = {min: 1024, max: 65536};
	this.items = [];
}

Uploader.prototype.getItems = function() {
	this.readData();
	this.fillSegments();
	return this.items;
}

Uploader.prototype.readData = function() {
	if (Request.TotalBytes < 1) return false;

	var block = {size: Math.round(this.size / 1000)};
	if (block.size < this.blockSize.min) block.size = this.blockSize.min;
	if (block.size > this.blockSize.max) block.size = this.blockSize.max;

	this.outputProgress();

	while (this.readSize < this.size) {
		if (this.readSize + block.size > this.size) block.size = this.size - this.readSize;
		block.data = Request.BinaryRead(block.size);
		this.stream.Write(block.data);
		this.readSize += block.size;

		this.outputProgress();
	}
}

Uploader.prototype.fillSegments = function() {
	this.stream.Position = 0;
	var data = this.stream.Read();
	this.separator = vbs_midB(data, 1, vbs_inStrB(1, data, vbs_crlf, 0) - 1);
	this.separatorLength = vbs_lenB(this.separator);

	var start = 1;
	start += this.separatorLength + 1;

	var infoEnd = 0;
	while (start + 3 < this.size) {
		infoEnd = vbs_inStrB(start, data, vbs_crlf + vbs_crlf, 0) + 3;
		var info = Uploader.binToString(this.stream, this.charset, start, infoEnd - start - 4);
		start = vbs_inStrB(infoEnd, data, this.separator, 0);

		var segment = {info: info, start: infoEnd, size: start - infoEnd - 3};
		var item = this.getForm(segment.info, segment.start, segment.size);
		this.items.push(item);

		start += this.separatorLength + 1;
	}
	delete data;
}

Uploader.prototype.getForm = function(info, start, size) {
	var item = {}
	info = new String(info);
	if (info.match(/ filename\=\"(.*?)\"/ig)) info.filename = RegExp.$1;
	if (info.match(/ name\=\"(.+?)\"/ig)) item.name = RegExp.$1;

	this.stream.Position = start;
	if (info.filename != undefined) { // A file
		var file = new UploaderFile();
		file.path = info.filename;
		file.name = file.path.substring(file.path.lastIndexOf("\\") + 1);
		if (info.match(/Content\-Type\: (.+?)$/ig)) file.contentType = RegExp.$1;
		file.size = size;
		file.setStreamSource(this.stream, start);
		item.value = file;
	} else item.value = Uploader.binToString(this.stream, this.charset, start, size);
	return item;
}

Uploader.prototype.outputProgress = function() {
	var file = this.fso.CreateTextFile(this.filePath, true);
	file.WriteLine("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
	file.WriteLine("<upload read=\"" + this.readSize + "\" total=\"" + this.size + "\" />");
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

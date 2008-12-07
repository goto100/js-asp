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
	this.readSize = 0;
	this.size = 0;
}

Uploader.prototype.getInput = function() {
	if (Request.TotalBytes < 1) return false;
	var input = {}

	;;; test.start();
	this.dataStream.Open();
	this.size = Request.TotalBytes;

	var block = {size: Math.round(this.size / 1000)};
	if (block.size < 65536) block.size = 65536; // 64kB
	var segments = [];
	var segment = {data: {start: 0, size: 0}, stream: this.dataStream};
	var item;

	var pos;
	var infoEnd;
	var separator;
	var separatorLength;

	this.outputProgress();
	var i = 0;
	while(this.readSize < this.size) {
		pos = 1;
		if (this.readSize + block.size > this.size) block.size = this.size - this.readSize;
		block.data = Request.BinaryRead(block.size); // 当前块
		this.readSize += block.size;
		this.dataStream.Write(block.data);
		if (i == 0) { // 第一块开头包含separator信息
			separator = vbs_midB(block.data, 1, vbs_inStrB(1, block.data, vbs_crlf, 0) - 1);
			separatorLength = vbs_lenB(separator);
		}

		infoEnd = 0;
		// 块前数据属上段
		var separatorAt = vbs_inStrB(pos, block.data, separator, 0);
		segment.data.size += separatorAt - pos;
		pos = separatorAt + separatorLength + 1;
		// 块中数据
		infoEnd = vbs_inStrB(pos, block.data, vbs_crlf + vbs_crlf, 0);
		while (infoEnd) {
			var infoStream = this.tempStream;
			infoStream.Type = 1;
			infoStream.Mode = 3;
			infoStream.Open();
			this.dataStream.Position = pos;
			this.dataStream.CopyTo(infoStream, infoEnd - pos - 1);
			pos = vbs_inStrB(infoEnd, block.data, separator, 0);
			infoStream.Position = 0;
			infoStream.Type = 2;
			infoStream.Charset = this.charset;
			segment.info = infoStream.ReadText();
			infoStream.Close();
			this.dataStream.Position = infoEnd + 3;
			segment.data.start = infoEnd;
			segment.data.size = pos - infoEnd;
			segments.push(segment);
			segment = {data: {start: 0, size: 0}, stream: this.dataStream};
			item = this.getForm(segment);
			if (instanceOf(item.value, UploaderFile)) {
				if (!input[item.name]) input[item.name] = [];
				if (item.value.name) input[item.name].push(item.value);
				item.value.setStreamSource(this.dataStream, infoEnd);
			} else {
				if (!input[item.name]) input[item.name] = item.value;
				else input[item.name] += ", " + item.value;
			}
			infoEnd = vbs_inStrB(pos, block.data, vbs_crlf + vbs_crlf, 0);
		}
		// 块末数据
		segment.data.start = infoEnd;

		i++;
		this.outputProgress();
	}

	;;; test.end("Load Request: ");
	return input;

}

Uploader.prototype.getForm = function(segment) {
	var item = {}
	info = new String(segment.info);
	if (info.match(/ filename\=\"(.*?)\"/ig)) info.filename = RegExp.$1;
	if (info.match(/ name\=\"(.+?)\"/ig)) item.name = RegExp.$1;

	if (info.filename != undefined) { // A file
		var file = new UploaderFile();
		file.path = info.filename;
		file.name = file.path.substring(file.path.lastIndexOf("\\") + 1);
		if (info.match(/Content\-Type\: (.+?)$/ig)) file.contentType = RegExp.$1;
		file.size = segment.data.size;
		item.value = file;
	} else { // A form item
		this.tempStream.Type = 1;
		this.tempStream.Mode = 3;
		this.tempStream.Open();
		segment.stream.CopyTo(this.tempStream, segment.data.size);
		this.tempStream.Position = 0;
		this.tempStream.Type = 2;
		this.tempStream.Charset = this.charset;
		item.value = this.tempStream.ReadText();
		this.tempStream.Close();
	}
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

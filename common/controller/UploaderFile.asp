<script language="javascript" runat="server">
function UploaderFile() {
	var stream;
	var start;

	this.name = null;
	this.contentType = null;
	this.size = 0;

	this.setStreamSource = function(fileStream, fileStart) {
		stream = fileStream;
		start = fileStart;
	}

	this.saveAs = function(path) {
		var builtStream = new ActiveXObject("ADODB.Stream");
		builtStream.Type = 1;
		builtStream.Mode = 3;
		builtStream.Open();
		stream.Position = start;
		stream.CopyTo(builtStream, this.size);
		builtStream.SaveToFile(path, 2);
		builtStream.Close();
		delete builtStream;
	}
}
</script>
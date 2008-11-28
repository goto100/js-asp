<%
//////////////////////////////////////////////////
// Class Name: File
// Author: ScYui
// Last Modify: 2005/11/
//////////////////////////////////////////////////

function FSO() {
	////////// Attributes //////////////////////////////
	// Private //////////

	// Public //////////

	////////// Methods //////////////////////////////

	// Private

	// Public //////////

	// Check folder
	this.folderExists = function(path) {
		var fso = FSO.create();
		return fso.folderExists(path);
	} 

	// Check file
	this.fileExists = function(path) {
		var fso = FSO.create();
		return fso.fileExists(path);
	} 

	// Create folder
	this.createPath = function(path) {
		var fso = FSO.create();
		var pathArr = path.split("\\");
		path = pathArr[0] + "\\";
		for (var i = 1; i < pathArr.length; i++) {
			path += pathArr[i] + "\\";
			if (!fso.folderExists(path)) fso.createFolder(path);
		}
	} 

	// Delete a file
	this.deleteFile = function(path) {
		var fso = FSO.create();
		if (fso.fileExists(path)) fso.getFile(path).Delete();
	}

	// Create file
	this.builtFile = function(path, content) {
		var stream = new ActiveXObject("ADODB.Stream");
		stream.type = 2;
		stream.mode = 3;
		stream.open();
		stream.charset = "utf-8";
		stream.position = stream.size;
		stream.writeText = content;
		stream.saveToFile(path, 2);
		stream.close();
	}
}

FSO.create = function() {
	return new ActiveXObject("Scripting.FileSystemObject");
}
%>
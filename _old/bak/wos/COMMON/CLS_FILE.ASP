<%
////////////////////////////////////////////////////////////
// Class File
//
// Last modify: 2005/6/20
// Author: ScYui
//
// Attributes: 
// Methods: 
////////////////////////////////////////////////////////////

function File() {
	////////// Attributes //////////////////////////////

	// Private //////////

	// Public //////////


	////////// Methods //////////////////////////////
	// Private //////////

	// Public //////////

	this.createFolder = function(strPath) {
		var fso = new ActiveXObject("Scripting.FileSystemObject");
		if (!fso.FolderExists(Server.MapPath(strPath))) {
			fso.CreateFolder(Server.MapPath(strPath));
			return true;
		}
		return false;
	}

	this.getTextFile = function(strPath) {
		var stream = new ActiveXObject("ADODB.Stream");
		with(stream) {
			Type = 2; // Text
			Mode = 3;
			Open();
			Charset = "utf-8";
			Position = Size;
			LoadFromFile(Server.MapPath(strPath));
			var str = ReadText();
			Close();
		}
			delete stream;

			return str;
	}

	this.writeFile = function(strPath, strContent) {
		var stream = new ActiveXObject("ADODB.Stream");
		with(stream) {
			Type = 2; // Text
			Mode = 3;
			Open();
			Charset = "utf-8";
			Position = Size;
			WriteText = strContent;
			SaveToFile(strPath, 2);
			Close();
		}
			delete stream;
	}
}
%>
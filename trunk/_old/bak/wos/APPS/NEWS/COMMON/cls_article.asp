<!-- #include file = "../../../common/cls_file.asp" -->
<%
////////////////////////////////////////////////////////////
// Class Article
//
// Last modify: 2005/6/1
// Author: ScYui
//
// Attributes: 
// Methods: 
////////////////////////////////////////////////////////////

function Article() {
	////////// Attributes //////////////////////////////

	// Private //////////
	var returnMessage = [];

	// Public //////////
	this.conn = PlugNews.conn;

	this.id;
	this.cateId
	this.cateName = "";
	this.publisherId;
	this.publisherName = "";
	this.builtFile = false;
	this.fileFolder = "";
	this.fileName = "";
	this.fileType;
	this.enableHTML = false;
	this.enableUBB = true;
	this.enableURL = true;
	this.enableImage = true;
	this.enableMedia = true;
	this.enableSmile = true;
	this.title = "";
	this.source = "";
	this.sourceLink = "";
	this.summary = "";
	this.content = "";
	this.dateTime = "";
	this.date = "";
	this.commentCount;
	this.viewCount;
	this.filePath = "";

	////////// Methods //////////////////////////////
	// Private //////////

	// Public //////////
	this.getFilePath = PlugNews.getFilePath;
	this.getFileType = PlugNews.getFileType;

	// Trun number to string
	this.getFileType = function(int) {
		if (int == 1) return ".html";
		if (int == 2) return ".asp";
	}

	// Fill all information to class
	this.fill = function(arr) {
		if (arr["arti_id"]) this.id = checkInt(arr["arti_id"]);
		this.cateId = checkInt(arr["arti_cateId"]);
		this.cateName = arr["cate_name"];
		this.publisherId = checkInt(arr["arti_publisherId"]);
		this.publisherName = arr["arti_publisherName"];
		this.builtFile = checkBool(arr["arti_builtFile"]);
		this.fileFolder = arr["arti_fileFolder"];
		this.fileName = arr["arti_fileName"];
		this.fileType = checkInt(arr["arti_fileType"]);
		this.enableHTML = checkBool(arr["arti_setting"].charAt(0));
		this.enableUBB = checkBool(arr["arti_setting"].charAt(1));
		this.enableURL = checkBool(arr["arti_setting"].charAt(2));
		this.enableImage = checkBool(arr["arti_setting"].charAt(3));
		this.enableMedia = checkBool(arr["arti_setting"].charAt(4));
		this.enableSmile = checkBool(arr["arti_setting"].charAt(5));
		this.title = arr["arti_title"];
		this.source = arr["arti_source"];
		this.sourceLink = arr["arti_sourceLink"];
		this.summary = arr["arti_summary"];
		this.content = arr["arti_content"];
		this.dateTime = arr["arti_dateTime"];
		// this.date = arr["arti_id"];
		this.commentCount = checkInt(arr["arti_commentCount"]);
		this.viewCount = checkInt(arr["arti_viewCount"]);
		// this.filePath = arr["arti_id"];
		this.setting = (this.enableHTML? "1":"0") + (this.enableUBB? "1":"0") + (this.enableURL? "1":"0") + (this.enableImage? "1":"0") + (this.enableMedia? "1":"0") + (this.enableSmile? "1":"0");
	}

	// Edit a news
	this.edit = function(arrInput) {
		this.conn.update("[news_Articles]", {	"arti_cateId":this.cateId
																	, "arti_publisherId":this.publisherId
																	, "arti_publisherName":this.publisherName
																	, "arti_builtFile":this.builtFile
																	, "arti_fileFolder":this.fileFolder
																	, "arti_fileName":this.fileName
																	, "arti_fileType":this.fileType
																	, "arti_setting":this.setting
																	, "arti_title":this.title
																	, "arti_source":this.source
																	, "arti_sourceLink":this.sourceLink
																	, "arti_summary":this.summary
																	, "arti_content":this.content
																	}, "arti_id=" + this.id
											);

		this.built();

		returnMessage.push(getLang("news") + getLang("edit_success"));
		return [returnMessage, 1];
	}

	// Built page
	this.built = function() {
		var fso = new ActiveXObject("Scripting.FileSystemObject");
		if (!fso.FolderExists(Server.MapPath(this.fileFolder))) {
			fso.CreateFolder(Server.MapPath(this.fileFolder));
			returnMessage.push("floder_created");
		}
		this.filePath = Server.MapPath(this.getFilePath(this.fileFolder, this.fileName, this.fileType));

		var stream = new File();
		var text = stream.getTextFile("../template/page.asp");
		var content = "<div id=\"article\">"
		+ "\r\n\<\%thePage.outputH2(\"" + this.title +"\")\%\>"
		+ "\r\n<div class=\"article\">"
		+ "\r\n" + this.content
		+ "\r\n</div>"
		+ "</div>";

		text = text.replace("<template:content />", content);
		stream.writeFile(this.filePath, text);
	}
}
%>
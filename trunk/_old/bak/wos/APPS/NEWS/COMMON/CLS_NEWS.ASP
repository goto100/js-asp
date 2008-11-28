<!-- #include file = "cls_article.asp" -->
<%
////////////////////////////////////////////////////////////
// Class PlugNews
//
// Last modify: 2005/6/1
// Author: ScYui
//
// Attributes: 
// Methods: 
////////////////////////////////////////////////////////////
function PlugNews(strDBPath, strName) {
	////////// Attributes //////////////////////////////
	// Private //////////
	var returnMessage = [];

	// Public //////////
	this.version = "v.1 beta";
	this.adminPanel = "<a href=\"article.asp?act=add\">" + getLang("add_news") + "</a>";
	this.conn = new DBConn(strDBPath, strName + ".conn");

	////////// Methods //////////////////////////////
	// Private //////////
	// Public //////////
	this.getFilePath = PlugNews.getFilePath;
	this.getFileType = PlugNews.getFileType;

	// Get all cagegories
	this.getCategories = function() {
		var categories = [];
		var tmpA = this.conn.query("SELECT cate_id, cate_name, cate_locked"
			+ " FROM [news_Categories]"
			+ " ORDER BY cate_rootOrder, cate_order");
		if (tmpA != null) {
			for (var i = 0; i < tmpA.length; i++) {
				categories[i] = [];
				var e = tmpA[i].getExpandoNames();
				for (var j = 0; j < e.length; j++) {
					categories[i][e[j].replace("cate_", "")] = tmpA[i][e[j]];
				}
			}
			return categories;
		}
	}

	// Get articles by category id
	this.getArticles = function(strCateId) {
		var articles = [];

		var sql = "SELECT a.arti_id, a.arti_cateId, a.arti_fileFolder, a.arti_fileName, a.arti_fileType, a.arti_title, a.arti_summary, a.arti_datetime, a.arti_commentCount, a.arti_viewCount, c.cate_name"
		+ " FROM [news_Articles] AS a, [news_Categories] AS c"
		+ " WHERE c.cate_id=a.arti_cateId"
		if (strCateId) sql += " AND c.cate_id=" + checkInt(strCateId);
		sql += " ORDER BY arti_datetime";

		var tmpA = this.conn.query(sql);
		if (tmpA != null) {
			for (var i = 0; i < tmpA.length; i++) {
				articles[i] = [];
				var e = tmpA.getExpandoNames();
				for (var j = 0; j < e.length; j++) {
					articles[i][e[j].replace("arti_", "")] = tmpA[i][e[j]];
				}
					articles[i].cateName = tmpA[i]["cate_name"];
					articles[i].path = this.getFilePath(tmpA[i]["arti_fileFolder"], tmpA[i]["arti_fileName"], tmpA[i]["arti_fileType"]);
					articles[i].date = getDateTimeString("YY-MM-DD", tmpA[i].datetime);
			}
			delete tmpA;

			return articles;
		}
	}

	// Get one news all information by Id
	this.getArticle = function(intId) {
		var tmpA = this.conn.query("SELECT TOP 1 a.*, c.cate_name"
			+ " FROM [news_Articles] AS a, [news_Categories] AS c"
			+ " WHERE c.cate_id=a.arti_cateId"
			+ " AND a.arti_id=" + intId);
		if (tmpA != null) {
			var tArticle = new Article();
			tArticle.fill(tmpA);
			return tArticle;
		}
	}

	// Add a category
	this.addCategory = function() {
		// ......
	}

	// Post a news
	this.addArticle = function(arr) {

		var tArticle = new Article();

		tArticle.fill(arr);

		if (!tArticle.cateId) returnMessage.push(getLang("category") + getLang("unselected"));
		if (!tArticle.title) returnMessage.push(getLang("title") + getLang("incomplete"));
		if (!tArticle.content) returnMessage.push(getLang("content") + getLang("incomplete"));
		if (tArticle.builtFile == true) {
			if ((!tArticle.fileFolder && tArticle.fileName)) {
				returnMessage.push(getLang("built_file_folder") + getLang("incomplete"));
			} else if ((!tArticle.fileName && tArticle.fileFolder)) {
				returnMessage.push(getLang("file_name") + getLang("incomplete"));
			}
		}
		if (returnMessage[0] != null) return [returnMessage];
		if (tArticle.content.length<2) return getLang("content_too_short");

		tArticle.conn.insert("[news_Articles]", {	"arti_cateId":this.cateId
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
																						}
											);

		return [getLang("post_success"), 1];
	}
	
	this.loadUserGroups = function(arrUserGroups, bOutput) {
		// Clone userGroups
		var userGroups = Object.clone(arrUserGroups);

		var tmpA = this.conn.query("SELECT *"
			+ " FROM [news_UserRight]");
		if (tmpA != null) {
			for (var i = 0; i < userGroups.length; i++) {
				for (var j = 0; j < tmpA.length; j++) {
					if (tmpA[j]["right_group_id"] == userGroups[i].id) {
						var userRight = tmpA[i]["right_value"].split(",");
						if (bOutput) { // Output mode check "default"
							userGroups[i].right = {	"view":userRight[0]
																		, "post":userRight[1]
																		, "edit":userRight[2]
																		, "del":userRight[3]
																		, "upload":userRight[4]
																		, "search":userRight[5]
																		, "manage":true
																		};
						} else {
							userGroups[i].right =
								{	"view":userRight[0] == 0? userGroups[i].right.view:userRight[0]
								, "post":userRight[1] == 0? userGroups[i].right.post:userRight[1]
								, "edit":userRight[2] == 0? userGroups[i].right.edit:userRight[2]
								, "del":userRight[3] == 0? userGroups[i].right.del:userRight[3]
								, "upload":userRight[4] == 0? userGroups[i].right.upload:userRight[4]
								, "search":userRight[5] == 0? userGroups[i].right.search:userRight[5]
								, "manage":true
								};
						}
					}
				}
			}
		}
		return userGroups;
	}

}

// Static
// Link folder, filename and filetype
PlugNews.getFilePath = function(strFolder, strName, strType) {
	return strFolder + strName + PlugNews.getFileType(strType);
}
// Trun number to string
PlugNews.getFileType = function(int) {
	if (int == 1) return ".html";
	if (int == 2) return ".asp";
}
%>
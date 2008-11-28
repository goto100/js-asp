<!-- #include file = "../../../../common/cls_userright.asp" -->
<%
var userRight = {	"view":{"name":getLang("view")
												, "rights":[getLang("default"], getLang("none"], getLang("normal"), getLang("hidden")]
													}
								, "post":{"name":getLang("post")
												, "rights":[getLang("default"], getLang("none"], getLang("comment"), getLang("news")]
												}
								, "edit":{"name":getLang("edit")
												, "rights":[getLang("default"], getLang("none"], getLang("self"), getLang("all")]
												}
								, "del":{	"name":getLang("delete")
												, "rights":[getLang("default"], getLang("none"], getLang("self"), getLang("all")]
												}
								, "upload":{"name":getLang("upload")
													, "rights":[getLang("default"], getLang("enabled"), getLang("disabled")]
													}
								, "search":{"name":getLang("search")
													, "rights":[getLang("default"], getLang("enabled"), getLang("disabled")]
													}
								};

var tRight = new UserRight(userRight);

tRight.submit = function(arr) {
	var ids = arr["group_id"].split(", ");
	var views = arr["group_right_view"].split(", ");
	var posts = arr["group_right_post"].split(", ");
	var edits = arr["group_right_edit"].split(", ");
	var dels = arr["group_right_del"].split(", ");
	var uploads = arr["group_right_upload"].split(", ");
	var searchs = arr["group_right_search"].split(", ");
	for (var i = 0; i < views.length; i++) {
		var sql = views[i] + "," + posts[i] + "," + edits[i] + "," + dels[i] + "," + uploads[i] + "," + searchs[i];
		appNews.conn.update("news_UserRight", {"right_value":sql}, "right_group_id=" + ids[i]);
	}
	return [getLang("user_right") + getLang("edit_success"), 1];
}

switch(query["act"]) {
	case "submit":
		thePage.outputAlert(tRight.submit(input));
		break;

	default:
		outputRight(appNews.loadUserGroups(theCache.userGroups, true), tRight.right);
}
%>
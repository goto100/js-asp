<!-- #include file = "../../common/cls_category.asp" -->
<%
var TCategory = function() {
	var tCate = new Category(theSite.conn, "site_Categories");
	this.get = function(intId, arr) {
		var category = tCate.get(intId, arr);
		category.setting.url = category.setting[0];
		return category;
	}
	this.add = function(arr) {
		arr["cate_setting"] = arr["cate_setting_url"];
		return tCate.add(arr);
	}
	this.edit = function(intId, arr) {
		arr["cate_setting"] = arr["cate_setting_url"];
		return tCate.edit(intId, arr);
	}
	this.getAll = tCate.getAll;
	this.del = tCate.del;
	this.move = tCate.move;
}
var tCate = new TCategory();

thePage.addPanel(getLang("category_manage"), ["<a href=\"?\">" + getLang("list") + "</a>", "<a href=\"?act=add\">" + getLang("add") + "</a>"]);

switch(query["act"]) {
	case "add":
		outputForm(false, tCate.getAll(["id", "name"], true));
		break;

	case "edit":
		if (!query["id"]) {
			thePage.outputAlert(getLang("bad_request"));
		} else {
			outputForm(true, tCate.getAll(["id", "name"], true), tCate.get(query["id"]));
		}
		break;

	case "up":
		if (!query["id"]) {
			thePage.outputAlert(getLang("bad_request"));
		} else {
			tCate.move(true, query["id"]);
		}
		theCache.loadCategories();
		Response.Redirect("category.asp");
		break;

	case "down":
		if (!query["id"]) {
			thePage.outputAlert(getLang("bad_request"));
		} else {
			tCate.move(false, query["id"]);
		}
		theCache.loadCategories();
		Response.Redirect("category.asp");
		break;

	case "doadd":
		var alert = tCate.add(input);
		theCache.loadCategories();
		thePage.outputAlert(alert);
		break;

	case "doedit":
		if (!query["id"]) {
			thePage.outputAlert(getLang("bad_request"));
		} else {
			var alert = tCate.edit(query["id"], input);
			theCache.loadCategories();
			thePage.outputAlert(alert);
		}
		break;

	case "dodel":
		var alert = tCate.del(query["id"]);
		theCache.loadCategories();
		thePage.outputAlert(alert);
		break;

	default:
		var categories = tCate.getAll(["id", "name", "description", "locked", "hidden", "rootId", "setting"]);
		var rootCategories = [];
		if (categories) {
			for (var i = 0; i < categories.length; i++) {
				if (categories[i].rootId == 0) {
					rootCategories.push(categories[i]);
				}
			}
		}
		outputCategory(categories, rootCategories);
}
%>
<!--#include file="../../../.class/system/HuanSystem.asp" -->
<!--#include file="../article/BlogArticle.asp" -->
<!--#include file="../article/BlogArticles.asp" -->
<!--#include file="../category/BlogCategory.asp" -->
<!--#include file="../setting/BlogSetting.asp" -->
<script language="javascript" runat="server">
function BlogSystem(dbPath) {
	System.apply(this, ["blog"]);

	var sysHuan = new HuanSystem(dbPath);

	this.version = "0.1 beta";
	this.updateDate = new Date("2006/8/29");

	this.db = null;
	this.cache = null;
	this.setting = null;
	this.userGroups = null;
	this.user = null;

	this.load = function() {
		sysHuan.load();
		this.db = sysHuan.db;
		this.cache = sysHuan.cache;
		this.setting = sysHuan.setting;
		this.userGroups = sysHuan.userGroups;
		this.user = sysHuan.user;
	}

	this.getCategory = function(id) {
		var category = new BlogCategory(id);
		category.setSystemSource(this);
		return category;
	}

	this.getArticle = function(id) {
		var article = new BlogArticle(id);
		article.setSystemSource(this);
		return article;
	}

	this.getArticles = function() {
		var articles = new BlogArticles;
		articles.setSystemSource(this);
		return articles;
	}
}
</script>
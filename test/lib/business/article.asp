<script language="javascript" runat="server">
Site.prototype.getArticleDao = function() {
	var dao = new ArticleDao();
	dao.db = this.db;
	return dao;
}

Site.prototype.getArticles = function(pageSize, currentPage) {
	var dao = this.getArticleDao();
	return dao.list(pageSize, currentPage);
}

Site.prototype.getArticle = function(id) {
	var dao = this.getArticleDao();
	return dao.get(id);
}

Site.prototype.saveArticle = function(article) {
	
}
</script>
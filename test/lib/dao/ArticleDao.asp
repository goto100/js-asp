<!--#include file="../../../src/dao/Dao.asp" -->
<!--#include file="../pojos/User.asp" -->
<script language="javascript" runat="server">
function ArticleDao() {
	this.tableName = "Articles";
}
ArticleDao.prototype = new Dao();

ArticleDao.prototype.toPojo = function(rec) {
	var article = new Article();
	article.title = rec.get("title");
	return article;
}

ArticleDao.prototype.fromPojo = function(user) {
	return new Map({
		username: user.username,
		password: user.password
	});
}
</script>
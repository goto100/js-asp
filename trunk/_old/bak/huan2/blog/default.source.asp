<%
function Main() {
	var actList = controller.addAction(new ListAction);
	var actRSS = controller.addAction(new ListAction, "rss");
	var actView = controller.addAction(new Action, "id");
	var actAdd = controller.addAction(new FormAction, "add");
	var actEdit = controller.addAction(new FormAction, "edit");
	var actSave = controller.addAction(new DBAction, "save");
	var actUpdate = controller.addAction(new DBAction, "update");

	actAdd.action = function() {
		var category = system.getCategory();
		category.load(true);
		outputer.outputAddForm(this.getValue(), category);
	}

	actSave.action = function() {
		this.withNumberParam("cateId", true);
		this.withStringParam("title", true);
		this.withStringParam("content");
		this.withStringParam("savedAction", "showArticle", null, null, ["continueAdd", "list", "showArticle", "editArticle"]);

		if (this.hasError) {
			var category = system.getCategory();
			category.load(true);
			outputer.outputAddForm(this.form, category);
		} else {
			var article = system.getArticle();
			article.save(this.param);
			controller.msg = "articleSaved";
			switch (this.param.savedAction) {
				case "continueAdd":
					actAdd.value = this.param;
					actAdd.action();
					break;
				case "list":
					actList.action();
					break;
				case "editArticle":
					actEdit.action();
					break;
				case "showArticle":
				default:
					actView.param.id = article.id;
					actView.action();
			}
		}
	}

	actEdit.action = function(article) {
		if (!article) {
			article = system.getArticle(this.getIdParam());
			article.load();
		}
		var category = system.getCategory();
		category.load(true);
		outputer.outputEditForm(this.getValue(article), category);
	}

	actUpdate.action = function() {
		this.withNumberParam("article.id", true);
		this.withNumberParam("article.category.id", true)
		this.withStringParam("article.title", true);
		this.withDateParam("article.postTime");
		this.withStringParam("article.content");
		this.withStringParam("update.action", "showArticle", null, null, ["continueEdit", "list", "showArticle"]);

		if (this.hasError) {
			var category = system.getCategory();
			category.load(true);
			outputer.outputEditForm(this.form, category);
		} else {
			var article = system.getArticle();
			article.update(this.param);
			controller.msg = "articleUpdated";
			switch (this.param.updatedAction) {
				case "continueEdit":
					actEdit.value = this.param;
					actEdit.action(article);
					break;
				case "list":
					actList.action();
					break;
				case "showArticle":
				default:
					actView.param.id = article.id;
					actView.action(article);
			}
		}
	}

	actView.action = function(article) {
		if (!article) {
			article = system.getArticle(this.getIdParam());
			article.load();
		}

		outputer.outputArticle(article);
	}

	actList.action = function() {
		var articles = system.getArticles();
		articles.setPage(this.getPageSize(20), this.getCurrentPage());
		articles.orders = this.getOrders("postTime~,title,category");
		if (this.search.cateId) articles.category = system.getCategory(parseInt(this.search.cateId));
		articles.load();

		outputer.outputArticles(articles);
	}

	actRSS.action = function() {
		var articles = system.getArticles();
		articles.setPage(20);
		articles.load();

		outputer.outputArticlesRSS(articles);
	}
}
%>
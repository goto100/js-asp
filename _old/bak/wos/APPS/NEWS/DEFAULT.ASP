<!-- #include file = "common/common.asp" -->
<!-- #include file = "../../skins/default/templates/content.asp" -->
<!-- #include file = "source/default.asp" -->
<%
function outputList(arrArticles) {
	if (theUser.right.post) thePage.addPanel(getLang("news_manage"), appNews.adminPanel);
	thePage.outputStart();
%>
<div id="articles"><%if (!arrArticles) {%>
	<p class="msg"><%=getLang("no_news_desc")%></p><%} else {%>
	<table class="list">
		<thead>
			<tr>
				<th scope="col"><%=getLang("title")%></th>
				<th scope="col"><%=getLang("in_category")%></th>
				<th scope="col"><%=getLang("post_date")%></th>
				<th scope="col"><%=getLang("comment")%></th>
				<th scope="col"><%=getLang("view")%></th><%if (theUser.right.edit) {%>
				<th scope="col"><%=getLang("edit")%></th><%}%>
			</tr>
		</thead>
		<tbody><%for (var i = 0; i < arrArticles.length; i++) {%>
			<tr>
				<td><a href="<%=arrArticles[i].path%>" title="<%=arrArticles[i].summary%>"><%=arrArticles[i].title%></a></td>
				<td><a href="?cate=<%=arrArticles[i].cateId%>"><%=arrArticles[i].cateName%></a></td>
				<td><%=arrArticles[i].date%></td>
				<td><%=arrArticles[i].commentCount%></td>
				<td><%=arrArticles[i].viewCount%></td><%if (theUser.right.edit) {%>
				<td><a href="article.asp?act=edit&id=<%=arrArticles[i].id%>"><%=getLang("edit")%></a></td><%}%>
			</tr><%}%>
		</tbody>

	</table><%}%>
</div>
<%
	thePage.outputSidebar();
	thePage.outputEnd();
}
%>
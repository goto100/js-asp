<!-- #include file = "common/common.asp" -->
<!-- #include file = "source/category.asp" -->
<%
function outputCategory(arrCategories, arrRootCategories) {
	thePage.outputStart(getLang("category_manage") + " - ");
%>
<div id="categories">
	<%thePage.outputH2(getLang("category_list"))%>
	<table class="form">
		<thead>
			<tr>
				<th scope="col"><%=getLang("name")%></th>
				<th scope="col"><%=getLang("order")%></th>
				<th scope="col"><%=getLang("edit")%></th>
				<th scope="col"><%=getLang("delete")%></th>
			</tr>
		</thead>
		<tbody><%if (!arrCategories) {%>
			<tr class="msg"><td colspan="4"><%=getLang("no_categories_desc")%></td></tr><%} else { for (var i = 0; i < arrCategories.length; i++) {%>
			<tr>
				<td><%if (arrCategories[i].rootId != 0) {%> - <%}%><a href="<%=arrCategories[i].setting.fullUrl%>"<%if (arrCategories[i].description) {%> title="<%=arrCategories[i].description%>"<%}%>><%=arrCategories[i].name%></a><%if (arrCategories[i].locked || arrCategories[i].hidden) { %> (<%if (arrCategories[i].locked) {%><em title="<%=getLang("locked")%>" class="note">L</em><%}%><%if (arrCategories[i].hidden) {%><em title="<%=getLang("hidden")%>" class="note">H</em><%}%>)<%}%></td>
				<td><a href="?act=up&amp;id=<%=arrCategories[i].id%>"><%=getLang("up")%></a> <a href="?act=down&amp;id=<%=arrCategories[i].id%>"><%=getLang("down")%></a></td>
				<td><a href="?act=edit&amp;id=<%=arrCategories[i].id%>"><%=getLang("edit")%></a></td>
				<td><a href="?act=dodel&amp;id=<%=arrCategories[i].id%>"><%=getLang("delete")%></a></td>
			</tr><%} }%>
		</tbody>
	</table>
	<p class="note"><%=getLang("delete_category_with_sub_desc")%></p>
</div>
<%
	thePage.outputSidebar();
	thePage.outputEnd();
}

function outputForm(bEdit, arrCategories, arrCategory) {
	thePage.outputStart(getLang("category_manage") + " - ");
%>
	<%thePage.outputH2(getLang("add_category"))%>
	<table class="form">
		<form method="post" action="?act=<%=bEdit? "doedit&amp;id=" + arrCategory.id:"doadd"%>">
		<tfoot>
			<tr>
				<td colspan="4"><input type="submit" value="<%=getLang("submit")%>" class="submit" /></td>
			</tr>
		</tfoot>
		<tbody>
			<tr>
				<th scope="row"><%=getLang("category_name")%>:</th>
				<td><input type="text" name="cate_name"<%if (bEdit) {%> value="<%=arrCategory.name%>"<%}%> class="text" /></td>
				<th scope="row"><%=getLang("in_category")%>:</th>
			  <td><%if (!bEdit) {%>
					<select name="cate_rootId">
						<option value="0"><%=getLang("root_category")%></option><%if (arrCategories) { for (var i = 0; i < arrCategories.length; i++) {%>
						<option value="<%=arrCategories[i].id%>"><%=arrCategories[i].name%></option><%} }%>
					</select><%} else {%><%=arrCategory.rootName%><%}%>
				</td>
			</tr>
			<tr>
				<th scope="row"><%=getLang("description")%>:</th>
				<td colspan="3"><input type="text" name="cate_description"<%if (bEdit) {%> value="<%=arrCategory.description%>"<%}%> size="50" class="text" /></td>
			</tr>
			<tr>
				<th scope="row"><%=getLang("intro")%>:</th>
				<td colspan="3"><textarea name="cate_intro" cols="30" rows="6"><%if (bEdit) {%><%=arrCategory.intro%><%}%></textarea> <em class="tip">(<%=getLang("html_allowed")%>)</em></td>
			</tr>
			<tr>
				<th scope="row"><%=getLang("locked")%>:</th>
				<td><input type="checkbox" name="cate_locked" value="1"<%if (bEdit && arrCategory.locked) {%> checked="true"<%}%> class="checkbox" /> <em class="note">(<%=getLang("locked_desc")%>)</em></td>
				<th scope="row"><%=getLang("hidden")%>:</th>
			  <td><input type="checkbox" name="cate_hidden" value="1"<%if (bEdit && arrCategory.hidden) {%> checked="true"<%}%> class="checkbox" /> <em class="note">(<%=getLang("hidden_desc")%>)</em></td>
			</tr>
			<tr>
				<th scope="row"><%=getLang("url")%>:</th>
				<td colspan="3"><input type="text" name="cate_setting_url" size="50"<%if (bEdit) {%> value="<%=arrCategory.setting.url%>"<%}%> size="40" class="text" /></td>
			</tr>
		</tbody>
		</form>
	</table><%if (!bEdit) {%>
	<p class="note"><%=getLang("order_desc")%></p><%}%>
<%
	thePage.outputSidebar();
	thePage.outputEnd();
}

function outputEdit() {
	thePage.outputStart(getLang("category_manage") + " - ");
%>
	<%thePage.outputH2(getLang("edit_category"))%>
<%
	thePage.outputSidebar();
	thePage.outputEnd();
}
%>
<!-- #include file = "common/common.asp" -->
<!-- #include file = "../../skins/default/templates/content.asp" -->
<!-- #include file = "source/article.asp" -->
<%
function outputForm(bEditMode, arrCategories, arrArticle) {
	thePage.mainFullWidth = true;
	thePage.outputStart();
%>
<script type="text/javascript" src="../../editor/fckeditor.js"></script>
<div id="<%=bEditMode? "edit":"add"%>">
	<table class="form">
		<form method="post" action="?act=do<%=bEditMode? "edit&amp;id=" + arrArticle.id: "add"%>">
		<tfoot>
			<tr>
				<td>&nbsp;</td>
				<td colspan="7"><input type="submit" value="<%=getLang("submit")%>" class="submit" /></td>
			</tr>
		</tfoot>
		<tbody>
			<tr>
				<th scope="row"><%=getLang("category")%></th>
				<td colspan="3">
					<select name="arti_cateId">
						<option value="0"><%=getLang("select_category")%></option><%if (arrCategories) { for (var i = 0; i < arrCategories.length; i++) {%>
						<option value="<%=arrCategories[i].id%>"<%if (bEditMode && arrArticle.cateId == arrCategories[i].id) {%> selected="true"<%}%><%if (arrCategories[i].locked){%> disabled="true"<%}%>><%=arrCategories[i].name%></option><%} }%>
					</select>
				</td>
				<th scope="row"><%=getLang("publisher")%></th>
				<td<%if (!bEditMode) {%> colspan="3"<%}%>><%=bEditMode? arrArticle.publisherName: theUser.username%><%if (!bEditMode) {%><input type="hidden" name="arti_publisherId" value="<%=theUser.id%>" /><input type="hidden" name="arti_publisherName" value="<%=theUser.username%>" /><%}%></td><%if (bEditMode) {%>
				<th scope="row"><%=getLang("delete")%></th>
				<td><a href="?act=dodel&id=<%=arrArticle.id%>"><%=getLang("delete")%>?</a></td><%}%>
			</tr>
			<tr>
				<th scope="row"><%=getLang("built_file")%></th>
				<td><input type="checkbox" name="arti_builtFile" value="1"<%if (bEditMode && arrArticle.builtFile) {%> checked="true"<%}%> /></td>
				<th scope="row"><%=getLang("type")%></th>
				<td><input type="radio" name="arti_fileType" value="1" disabled="true" />html
				  	<input type="radio" name="arti_fileType" value="2"<%if (bEditMode && arrArticle.fileType == 2) {%>checked="true"<%}%> />asp</td>
				<th scope="row"><%=getLang("built_file_folder")%></th>
				<td><input type="text" name="arti_fileFolder"<%if (bEditMode) {%>value="<%=arrArticle.fileFolder%>"<%}%> size="20" /></td>
				<th scope="row"><%=getLang("file_name")%></th>
				<td><input type="text" name="arti_fileName"<%if (bEditMode) {%>value="<%=arrArticle.fileName%>"<%}%> size="10" /></td>
				</tr>
			<tr>
				<th scope="row"><%=getLang("title")%></th>
				<td colspan="7"><input type="text" name="arti_title"<%if (bEditMode) {%>value="<%=arrArticle.title%>"<%}%> size="60" class="text" /></td>
			</tr>
			<tr>
				<th scope="row"><%=getLang("source")%></th>
				<td colspan="3"><input type="text" name="arti_source"<%if (bEditMode) {%>value="<%=arrArticle.source%>"<%}%> size="20" class="text" /></td>
				<th scope="row"><%=getLang("source_link")%></th>
				<td colspan="3"><input type="text" name="arti_sourceLink"<%if (bEditMode) {%>value="<%=arrArticle.sourceLink%>"<%}%> size="50" class="text" /></td>
			</tr>
			<tr>
				<td rowspan="4">
					<h3><%=getLang("option")%></h3>
					<ul>
						<li><input type="checkbox" name="arti_setting_html" value="1" />&nbsp;<%=getLang("enable_html")%></li>
						<li><input type="checkbox" name="arti_setting_ubb" value="1"<%if (bEditMode && arrArticle.enableUBB) {%> checked="true"<%}%> />&nbsp;<%=getLang("enable_ubb_code")%></li>
						<li><input type="checkbox" name="arti_setting_url" value="1"<%if (bEditMode && arrArticle.enableURL) {%> checked="true"<%}%> />&nbsp;<%=getLang("auto_convert_url")%></li>
						<li><input type="checkbox" name="arti_setting_image" value="1"<%if (bEditMode && arrArticle.enableImage) {%> checked="true"<%}%> />&nbsp;<%=getLang("show_images")%></li>
						<li><input type="checkbox" name="arti_setting_media" value="1"<%if (bEditMode && arrArticle.enableMedia) {%> checked="true"<%}%> />&nbsp;<%=getLang("show_medias")%></li>
						<li><input type="checkbox" name="arti_setting_smile" value="1"<%if (bEditMode && arrArticle.enableSmile) {%> checked="true"<%}%> />&nbsp;<%=getLang("show_smiles")%></li>
					</ul>
					<h3><%=getLang("smile_icon")%></h3><%for (var i = 0; i < theCache.smiles.length; i++) {%>
					<a href="article.asp"><img src="<%=theCache.setting.sitePath + theCache.smiles[i].filePath%>" alt="<%=theCache.smiles[i].name%>" /></a><%}%>
				</td>
				<th colspan="7" scope="col"><%=getLang("summary")%></th>
			</tr>
			<tr>
				<td colspan="7"><textarea name="arti_summary" rows="5" cols="60"><%if (bEditMode) {%><%=arrArticle.summary%><%}%></textarea></td>
			</tr>
			<tr>
				<th colspan="7" scope="col"><%=getLang("content")%></th>
			</tr>
			<tr>
				<td colspan="7">
			<script type="text/javascript">
<!--
var sBasePath = "/wos/editor/" ;

var oFCKeditor = new FCKeditor( "arti_content" ) ;
oFCKeditor.BasePath		= sBasePath ;
oFCKeditor.Value = "<%if (bEditMode) {%><%=arrArticle.content%><%}%>";
oFCKeditor.Create() ;
//-->
			</script>
				</td>
			</tr>
		</tbody>
		</form>
	</table>
</div>
<%
	thePage.outputEnd();
}
%>
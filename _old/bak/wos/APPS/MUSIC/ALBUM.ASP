<!-- #include file = "common/common.asp" -->
<!-- #include file = "../../skins/default/templates/content.asp" -->
<!-- #include file = "source/album.asp" -->
<%
function outputAddAlbum() {
	if (theUser.right.post) thePage.addPanel(undefined, adminPanel);
	thePage.outputStart();
%>
<div id="add">
	<table class="form">
		<form method="post" action="../../Music/?act=doadd">
		<tfoot>
			<tr>
				<td colspan="2"><input type="submit" value="<%=getLang("submit")%>" class="submit" /></td>
			</tr>
		</tfoot>
		<tbody>
			<tr>
				<th scope="row"><%=getLang("album_name")%></th>
				<td><input type="text" name="album_name" size="40" class="text" /></td>
			</tr>
		</tbody>
		</form>
	</table>
</div>
<%
	thePage.outputSidebar();
	thePage.outputEnd();
}

function outputEditAlbum(arrAlbum, arrSongs){
	if (theUser.right.post) thePage.addPanel(undefined, adminPanel);
	thePage.outputStart();
%>
<div id="add">
	<table class="form">
		<form method="post" action="../../Music/?act=doedit&name=<%=arrAlbum["album_name"]%>">
		<tfoot>
			<tr>
				<td colspan="4"><input type="submit" value="<%=getLang("submit")%>" class="submit" /></td>
			</tr>
		</tfoot>
		<tbody>
			<tr>
				<th scope="row"><%=getLang("album_name")%></th>
				<td><input type="text" name="album_name" size="40" value="<%=arrAlbum["album_name"]%>" class="text" /></td>
				<th scope="row"><%=getLang("delete")%></th>
				<td><a href="?act=dodel&name=<%=arrAlbum["album_name"]%>" onclick="return confirm('<%=getLang("confirm_to_delete_desc")%>')"><%=getLang("delete")%>?</a></td>
			</tr>
			<tr>
				<th scope="row"><%=getLang("add_song")%></th>
				<td>
					<select name="song_name">
						<option selected="true" value="0"><%=getLang("select_add_song_desc")%></option><%for (var i = 0; i < arrSongs.length; i++) {%>
						<option value="<%=arrSongs[i]["fullName"]%>"><%=arrSongs[i]["fullName"]%></option><%}%>
					</select>
				</td>
				<th scope="row"><%=getLang("song_order")%></th>
			  <td><input type="text" name="song_order" size="2" maxlength="2" class="text" /></td>
			</tr>
		</tbody>
		</form>
	</table>
	<%if (arrAlbum["album_songs"]) {%>
	<table class="form">
		<tbody>
			<tr>
				<th scope="row" rowspan="<%=arrAlbum["album_songs"].length + 1%>"><%=getLang("song_list")%></th>
				<th scope="col"><%=getLang("song_name")%></th>
				<th scope="col"><%=getLang("song_order")%></th>
				<th scope="col"><%=getLang("delete")%></th>
				<th scope="col"><%=getLang("submit_edit")%></th>
			</tr><%for (var i = 0; i < arrAlbum["album_songs"].length; i++) {%>
			<tr>
				<form method="post" action="../../Music/?act=doeditsong&name=<%=arrAlbum["album_name"]%>">
				<td><%=arrAlbum["album_songs"][i]["name"]%><input type="hidden" name="song_name" value="<%=arrAlbum["album_songs"][i]["name"]%>" /></td>
				<td><input type="text" name="song_order" size="2" maxlength="2" value="<%=arrAlbum["album_songs"][i]["order"]%>" /></td>
				<td><a href="?act=dodelsong&name=<%=arrAlbum["album_name"]%>&songname=<%=arrAlbum["album_songs"][i]["name"]%>" onclick="return confirm('<%=getLang("confirm_to_delete_desc")%>')"><%=getLang("delete")%>?</a></td>
				<td><input type="submit" value="<%=getLang("submit_edit")%>" class="submit" /></td>
				</form>
			</tr><%}%>
		</tbody>
	</table><%}%>
</div>
<%
	thePage.outputSidebar();
	thePage.outputEnd();
}


function outputListAlbum(arrAlbums) {
	if (theUser.right.post) thePage.addPanel(undefined, adminPanel);
	thePage.outputStart();
%>
<div id="albums"><%if (!arrAlbums) {%>
	<p class="msg"><%=getLang("no_albums_desc")%></p><%} else {%>
	<table class="list">
		<thead>
			<tr>
				<th scope="col"><%=getLang("album_name")%></th>
				<th scope="col"><%=getLang("song_list")%></th><%if (theUser.right.post) {%>
				<th scope="col"><%=getLang("edit_album")%></th><%}%>
			</tr>
		</thead>
		<tfoot>
			<tr>
			</tr>
		</tfoot>
		<tbody><%for (var i = 0; i < arrAlbums.length; i++) {%>
			<tr>
				<td><%=arrAlbums[i]["album_name"]%></td>
				<td></td><%if (theUser.right.post) {%>
				<td><a href="?act=edit&name=<%=arrAlbums[i]["album_name"]%>"><%=getLang("edit_album")%></a></td><%}%>
			</tr><%}%>
		</tbody>
	</table><%}%>
</div>
<%
	thePage.outputSidebar();
	thePage.outputEnd();
}
%>
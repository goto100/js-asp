<!-- #include file = "common/common.asp" -->
<!-- #include file = "../../skins/default/templates/content.asp" -->
<!-- #include file = "source/song.asp" -->
<%
function outputAddSong() {
	if (theUser.right.post) thePage.addPanel(undefined, adminPanel);
	thePage.outputStart();
%>
<div id="add">
	<table class="form">
		<form method="post" action="../../Music/?act=doadd">
		<tfoot>
			<tr>
				<td colspan="4"><input type="submit" value="<%=getLang("submit")%>" class="submit" /></td>
			</tr>
		</tfoot>
		<tbody>
			<tr>
				<th scope="row"><%=getLang("song_name")%></th>
				<td colspan="3"><input type="text" name="song_name" size="40" class="text" /></td>
				<th scope="row">&nbsp;</th>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<th scope="row"><%=getLang("author")%></th>
				<td colspan="3"><input type="text" name="song_author" size="40" class="text" /></td>
				<th scope="row"><%=getLang("version")%></th>
				<td><input type="text" name="song_version" size="15" class="text" /></td>
			</tr>
			<tr>
				<th scope="row"><%=getLang("lyric")%></th>
				<td colspan="5"><textarea name="song_lyric" rows="10"></textarea></td>
			</tr>
			<tr>
				<th scope="row"><%=getLang("copyrights")%></th>
				<td colspan="3"><input type="text" name="song_copyrights" size="40" class="text" /></td>
			<th scope="row"><%=getLang("online_listen")%></th>
			  <td><input type="checkbox" name="song_listen" value="1" class="text" /></td>
			</tr>
		</tbody>
		</form>
	</table>
</div>
<%
	thePage.outputSidebar();
	thePage.outputEnd();
}

function outputEditSong(arrSong) {
	if (theUser.right.post) thePage.addPanel(undefined, adminPanel);
	thePage.outputStart();
%>
<div id="editsong">
<table class="form">
		<form method="post" action="../../Music/?act=doedit">
		<tfoot>
			<tr>
				<td colspan="4"><input type="submit" value="<%=getLang("submit")%>" class="submit" /></td>
			</tr>
		</tfoot>
		<tbody>
			<tr>
				<th scope="row"><%=getLang("song_name")%></th>
				<td colspan="3"><input type="hidden" name="song_id" value="<%=arrSong["song_id"]%>" /><input type="text" name="song_name" size="40" value="<%=arrSong["song_name"]%>" class="text" /></td>
				<th scope="row"><%=getLang("delete")%></th>
			  <td><a href="?act=dodel&id=<%=arrSong["song_id"]%>" onclick="return confirm('<%=getLang("confirm_to_delete_desc")%>')"><%=getLang("delete")%>?</a></td>
			</tr>
			<tr>
				<th scope="row"><%=getLang("author")%></th>
				<td colspan="3"><input type="text" name="song_author" size="40" value="<%=arrSong["song_author"]%>" class="text" /></td>
			<th scope="row"><%=getLang("version")%></th>
			  <td><input type="text" name="song_version" size="15" value="<%=arrSong["song_version"]%>" class="text" /></td>
			</tr>
			<tr>
				<th scope="row"><%=getLang("lyric")%></th>
				<td colspan="7"><textarea name="song_lyric" rows="10"><%=arrSong["song_lyric"]%></textarea></td>
			</tr>
			<tr>
				<th scope="row"><%=getLang("copyrights")%></th>
				<td colspan="3"><input type="text" name="song_copyrights" size="40" value="<%=arrSong["song_copyrights"]%>" class="text" /></td>
				<th scope="row"><%=getLang("online_listen")%></th>
				<td colspan="3"><input type="checkbox" name="song_listen" value="1" <%if (arrSong["song_listen"]) {%>checked="true" <%}%>class="text" /></td>
			</tr>
		</tbody>
		</form>
	</table>
</div>
<%
	thePage.outputSidebar();
	thePage.outputEnd();
}

function outputListSong(arrSongs) {
	if (theUser.right.post) thePage.addPanel(undefined, adminPanel);
	thePage.outputStart();
%>
<div id="songs"><%if (!arrSongs) {%>
	<p class="msg"><%=getLang("no_songs_desc")%></p><%} else {%>
	<table class="list">
		<thead>
			<tr>
				<th scope="col"><%=getLang("song_name")%></th>
				<th scope="col"><%=getLang("in_album")%></th>
				<th scope="col"><%=getLang("online_listen")%></th><%if (theUser.right.post) {%>
				<th scope="col"><%=getLang("edit_song")%></th><%}%>
			</tr>
		</thead>
		<tfoot>
			<tr>
			</tr>
		</tfoot>
		<tbody><%for (var i = 0; i < arrSongs.length; i++) {%>
			<tr>
				<td><%=arrSongs[i]["fullName"]%></td>
				<td><%if (arrSongs[i]["albumNames"]) {%>
					<ul><%for (var j = 0; j < arrSongs[i]["albumNames"].length; j++)
 {%>
						<li><a href="album.asp?name=<%=arrSongs[i]["albumNames"][j]%>"><%=arrSongs[i]["albumNames"][j]%></a></li><%}%>
					</ul><%} else {%>&nbsp;<%}%>
				</td>
				<td><%=arrSongs[i]["song_listen"]? "<a href=\"listen.asp?name=" + Server.URLEncode(arrSongs[i]["fullName"]) + "\">" + getLang("online_listen") + "</a>":"&nbsp;"%></td><%if (theUser.right.post) {%>
				<td><a href="song.asp?act=edit&id=<%=arrSongs[i]["song_id"]%>"><%=getLang("edit_song")%></a></td><%}%>
			</tr><%}%>
		</tbody>
	</table><%}%>
</div>
<%
	thePage.outputSidebar();
	thePage.outputEnd();
}
%>
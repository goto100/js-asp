<!-- #include file = "../../../_common.asp" -->
<!-- #include file = "../../../langs/zh-cn/music.asp" -->
<%
var plugin = "music";
var connMusic = new DBConn(theSite.plugin.Music.dbPath, "connMusic");

getMusicLanguageArray(lang);

function toFullSongName(strName, strVersion) {
	var fullName = strName;
	if (strVersion != "#") {
		fullName = strName + "(" + strVersion + ")";
	}

	return fullName;
}

var adminPanel = ["<a href=\"song.asp\">" + getLang("song_list"] + "</a>", "<a href=\"album.asp\">" + getLang("album_list"] + "</a>", "<a href=\"song.asp?act=add\">" + getLang("add_song"] + "</a>", "<a href=\"album.asp?act=add\">" + getLang("add_album") + "</a>");
%>
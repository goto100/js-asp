<%
switch(query["act"]) {
	case "add":
		outputAddAlbum();
		break;

	case "edit":
		if (!query["name"]) thePage.outputAlert([getLang("bad_request")]);

		var songs = connMusic.query("SELECT song_name, song_version"
			+ " FROM [music_Songs]"
			+ " ORDER BY song_name");

		var album = connMusic.query("SELECT TOP 1 album_name, album_songs"
			+ " FROM [music_Albums]"
			+ " WHERE album_name='" + query["name"] + "'");
		if (!album) thePage.outputAlert([getLang("bad_request")]);

		if (album["album_songs"]) {
			album["album_songs"] = unlinkSongs(album["album_songs"]);
		}

		for (var i = 0; i < songs.length; i++) {
			songs[i]["fullName"] = toFullSongName(songs[i]["song_name"], songs[i]["song_version"]);
			if (album["album_songs"]) {
				for (var j = 0; j < album["album_songs"].length; j++)
 {
					if (songs[i]["fullName"] == album["album_songs"][j]["name"]) {
						songs.splice(i, 1); // delete this item
						i--;
						break;
					}
				}
			}
		}

		outputEditAlbum(album, songs);
		break;

	case "doadd":
		thePage.outputAlert(addAlbum(input["album_name"]));

	case "doedit":
		thePage.outputAlert(editAlbum(query["name"], input["album_name"], input["song_name"], input["song_order"]));
		break;

	case "dodel":
		thePage.outputAlert([delAlbum(query["name"])]);
		break;

	case "doeditsong":
		thePage.outputAlert(editAlbumSong(query["name"], input["song_name"], input["song_order"]));
		break;

	case "dodelsong":
		thePage.outputAlert(1, undefined, delAlbumSong(query["name"], query["songname"]));
		break;

	default:
		var albums = connMusic.query("SELECT album_name"
			+ " FROM [music_Albums]"
			+ " ORDER BY album_name");

		outputListAlbum(albums);
}





function addAlbum(strName) {
	if (!strName) return getLang("album_name") + getLang("incomplete");

	connMusic.insert("[music_Albums]", {"album_name":strName});

	return [0, getLang("submit_success_desc")];
}

function delAlbum(strName) {
	if (!strName) return getLang("bad_request");

	var tmpA = connMusic.query("SELECT song_id, song_albums"
			+ " FROM [music_Songs]"
			+ " WHERE song_albums LIKE '%" + strName + ",%'");

	if (tmpA != null) {
		var songs = [];
		for (var i = 0; i < tmpA.length; i++) {
			songs[i] = {"id":tmpA[i]["song_id"], "albums":tmpA[i]["song_albums"].split(",")}
			for (var j = 0; j < songs[i]["albums"].length; j++)
 {
				if (songs[i]["albums"][j] == strName) {
					songs[i]["albums"].splice(j, 1);
					j--;
					break;
				}
			}
		}
		for (var i = 0; i < songs.length; i++) {
			var sql = songs[i]["albums"].join(",");
			connMusic.update("music_Songs", {"song_albums":sql}, "song_id=" + songs[i]["id"]);
		}
	}

	connMusic.del("music_Albums", "album_name='" + strName + "'");
	return [0, getLang("delete_success")];
}

function editAlbum(strQName, strName, strSongName, strSongGrad) {
	if (!strQName) return getLang("bad_request");
	if (!strName) return getLang("album_name") + getLang("incomplete");

	if (strQName != strName) { // Change album names in songs
		var tmpA = connMusic.query("SELECT song_id, song_albums"
			+ " FROM [music_Songs]"
			+ " WHERE song_albums LIKE '%" + strQName + ",%'");
		if (tmpA != null) {
			var songs = [];
			for (var i = 0; i < tmpA.length; i++) {
				songs[i] = {"id":tmpA[i]["song_id"], "albums":tmpA[i]["song_albums"].split(",")}
				for (var j = 0; j < songs[i]["albums"].length; j++)
 {
					if (songs[i]["albums"][j] == strQName) {
						songs[i]["albums"][j] = strName;
						break;
					}
				}
			}
			for (var i = 0; i < songs.length; i++) {
				var sql = songs[i]["albums"].join(",");
				connMusic.update("music_Songs", {"song_albums":sql}, "song_id=" + songs[i]["id"]);
			}
		}
	}

	if (strSongName != "0") { // Add a song
		if (!strSongGrad) return getLang("song_order") + getLang("incomplete");

		var songNames = connMusic.query("SELECT TOP 1 album_songs"
			+ " FROM [music_Albums]"
			+ " WHERE album_name='" + strQName + "'");
		songNames = songNames["album_songs"];

		if (songNames == null) {
			songNames = (strSongName + ":" + strSongGrad + ",");
		} else if (songNames.indexOf(strSongName + ":") != -1) {
			return [0, getLang("have_same_song_desc")];
		} else {
			songNames += (strSongName + ":" + strSongGrad + ",");
			var songs = unlinkSongs(songNames);
			sortSongs(songs);
			songNames = linkSongs(songs);
		}

		// Write to songs album name
		var songName = getSongName(strSongName);
		var songVersion = getSongVersion(strSongName);
		var noVersion = true;
		var tmp = connMusic.query("SELECT TOP 1 song_albums"
			+ " FROM [music_Songs]"
			+ " WHERE song_name='" + strSongName + "'");
		if (!tmp) {
			var noVersion = false;
			tmp = connMusic.query("SELECT TOP 1 song_albums"
			+ " FROM [music_Songs]"
			+ " WHERE song_name='" + songName + "'"
			+ " AND song_version='" + songVersion +"'");
		}
		if (!tmp) return getLang("not_find_song");
		if (tmp["song_albums"]) var sql = tmp["song_albums"] + strName + ",";
		else var sql = strName + ",";
		delete tmp;
		if (noVersion) {
			connMusic.update("music_Songs", {"song_albums":sql}, "song_name='" + strSongName + "'");
		} else {
			connMusic.update("music_Songs", {"song_albums":sql}, "song_name='" + songName + "' AND song_version='" + songVersion + "'");
		}
	}

	connMusic.update("music_Albums", {"album_name":strName, "album_songs":songNames}, "album_name='" + strQName + "'");

	return [0, getLang("submit_success_desc")];
}

function editAlbumSong(intId, strSongName, strSongGrad) {
	if (!intId) return getLang("bad_request");
	if (!strSongName) return getLang("bad_request");
	if (!strSongGrad) return getLang("song_order") + getLang("incomplete");

	intId = checkInt(intId);

	var songNames = connMusic.query("SELECT TOP 1 album_songs"
		+ " FROM [music_Albums]"
		+ " WHERE album_id=" + intId);
	songNames = songNames["album_songs"];

	var songs = unlinkSongs(songNames);

	for (var i = 0; i < songs.length; i++) {
		if (songs[i].name == strSongName) {
			songs[i].order = strSongGrad;
		}
	}

	sortSongs(songs);

	songNames = linkSongs(songs);

	connMusic.update("music_Albums", {"album_songs":songNames}, "album_id=" + intId);
	return [0, getLang("submit_success")];
}

function delAlbumSong(intId, strSongName) {
	if (!intId || !strSongName) return getLang("bad_request");

	intId = checkInt(intId);

	var songNames = connMusic.query("SELECT TOP 1 album_songs"
		+ " FROM [music_Albums]"
		+ " WHERE album_id=" + intId);
	songNames = songNames["album_songs"];

	var songs = unlinkSongs(songNames);

	for (var i = 0; i < songs.length; i++) {
		if (songs[i].name == strSongName) {
			songs.splice(i, 1); // delete this item
			i--;
			break;
		}
	}

	songNames = linkSongs(songs);

	connMusic.update("music_Albums", {"album_songs":songNames}, "album_id=" + intId);
	return [0, getLang("submit_success")];
}



function sortSongs(arrSongs) {
	for (var i = 0; i < arrSongs.length-1; i++) {
		for (var j=1; j < arrSongs.length-i; j++)
 {
			if (arrSongs[j].order<arrSongs[j-1].order) {
				var tmp = arrSongs[j-1];
				arrSongs[j-1] = arrSongs[j];
				arrSongs[j] = tmp;
			}
		}
	}

	return arrSongs;
}

function unlinkSongs(arrSongs) {
	arrSongs = arrSongs.slice(0, -1);
	arrSongs = arrSongs.split(",");
	var tmp = [];
	for (var i = 0; i < arrSongs.length; i++) {
		tmp[i] = {"name":arrSongs[i].slice(0, arrSongs[i].indexOf(":")), "order":checkInt(arrSongs[i].slice(arrSongs[i].indexOf(":") + 1))};
	}

	return tmp;
}

function linkSongs(arrSongs) {
	var tmp = "";
	for (var i = 0; i < arrSongs.length; i++) {
		tmp += (arrSongs[i].name + ":" + arrSongs[i].order + ",");
	}

	return tmp;
}


function getSongName(strName) {
	if (strName.indexOf("(") == -1) return strName;
	return strName.slice(0, strName.indexOf("("));
}
function getSongVersion(strName) {
	if (strName.indexOf("(") == -1) return undefined;
	return strName.slice(strName.indexOf("(") + 1, strName.indexOf(")"));
}
%>
<%
switch(query["act"]) {
	case "add":
		outputAddSong();
		break;

	case "edit":
		if (!query["id"]) thePage.outputAlert([getLang("bad_request")]);
		var song = connMusic.query("SELECT TOP 1 song_id, song_name, song_version, song_author, song_lyric, song_copyrights, song_listen"
			+ " FROM [music_Songs]"
			+ " WHERE song_id=" + checkInt(query["id"]));

		outputEditSong(song);
		break;

	case "doadd":
		thePage.outputAlert(addSong(input["song_name"], input["song_version"], input["song_listen"], input["song_author"], input["song_lyric"], input["song_copyrights"]));

	case "dodel":
		break;

	case "doedit":
		thePage.outputAlert(editSong(input["song_id"], input["song_name"], input["song_version"], input["song_listen"], input["song_author"], input["song_lyric"], input["song_copyrights"]));
		break;

	default:
		var songs = connMusic.query("SELECT song_id, song_name, song_version, song_albums, song_listen"
			+ " FROM [music_Songs]"
			+ " ORDER BY song_name");

		for (var i = 0; i < songs.length; i++) {
			songs[i]["fullName"] = toFullSongName(songs[i]["song_name"], songs[i]["song_version"]);
		}

		for (var i = 0; i < songs.length; i++) { // Get album names
			if (songs[i]["song_albums"]) {
				var albumNames = songs[i]["song_albums"].split(", ");
				songs[i]["albumNames"] = [];
				for (var j = 0; j < albumNames.length; j++)
 {
					songs[i]["albumNames"][j] = albumNames[j];
				}
			}
		}

		outputListSong(songs);
}

function addSong(strName, strVersion, bListen, strAuthor, strLyric, strCopyright) {
	if (!strName) return getLang("song_name") + getLang("incomplete");
	if (!strVersion) strVersion="#";
	bListen = checkBool(bListen);

	connMusic.insert("[music_Songs]", {"song_name":strName, "song_version":strVersion, "song_listen":bListen, "song_author":strAuthor, "song_lyric":strLyric, "song_copyrights":strCopyright});

	return [0, getLang("submit_success_desc")];
}

function editSong(intId, strName, strVersion, bListen, strAuthor, strLyric, strCopyright) {
	if (!intId) return getLang("bad_request");
	if (!strName) return getLang("song_name") + getLang("incomplete");
	intId = checkInt(intId);
	if (!strVersion) strVersion="#";
	bListen = checkBool(bListen);

	connMusic.update("music_Songs", {"song_name":strName, "song_version":strVersion, "song_listen":bListen, "song_author":strAuthor, "song_lyric":strLyric, "song_copyrights":strCopyright}, "song_id=" + intId);

	return [0, getLang("submit_success_desc")];
}
%>
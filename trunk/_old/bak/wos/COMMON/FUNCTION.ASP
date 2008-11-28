<%
Object.prototype.getExpandoNames = function() {
	var values = [];
	var obj = new this.constructor();
	for (var i in this) {
		if (obj[i] != this[i]) {
			values.push(i);
		}
	}
	return values;
}

// Object clone ---------------------------------------------
Object.prototype.clone = function(obj) {
	var objClone = new obj.constructor();
	var e = this.getExpandoNames();
	for (var i = 0; i < e.length; i++) {
		if (objClone[e[i]] != obj[e[i]]) { 
			if (typeof(obj[e[i]]) == "object") { 
				objClone[e[i]] = Object.clone(obj[e[i]]);
			} else {
				objClone[e[i]] = obj[e[i]];
			}
		}
	}
	if (!objClone || ("" + objClone) == "") {
		return (new String(obj) + objClone) ? obj : objClone;
	} else {
		objClone.toString = obj.toString;
		return objClone;
	}
}

// String Length with Double Bytes Language Support ----------
String.prototype.lengthW = function() {
	if (this == undefined){ return 0; }
	var tLen=0;
	for (var i = 0; i < this.length; i++){
		charCode=this.charCodeAt(i);
		if (charCode < 0 || charCode > 255) {
			tLen +=  2;
		} else {
			tLen++;
		}
	}
	return tLen;
}


// HTMLEncode String -----------------------------------------
function HTMLEncode (str){
	if (str == undefined){ return ""; }
	str = str.replace(/\&/g, "&amp;");
	str = str.replace(/\>/g, "&gt;");
	str = str.replace(/\</g, "&lt;");
	str = str.replace(/\t/g, "&nbsp;&nbsp;");
	str = str.replace(/\"/g, "&quot;");
	str = str.replace(/\'/g, "&#39;");
	str = str.replace(/\n/g, "<br />");
	return str;
}

// HTMLEncode For Textarea -----------------------------------
function HTMLEncodeLite (str){
	if (str == undefined){ return ""; }
	str = str.replace(/\&/g, "&amp;");
	str = str.replace(/\>/g, "&gt;");
	str = str.replace(/\</g, "&lt;");
	str = str.replace(/\"/g, "&quot;");
	str = str.replace(/\'/g, "&#39;");
	return str;
}

// Cut Long String -------------------------------------------
String.prototype.cutString = function(outputLen){
	var strLen, tLen, charCode;
	if (this == undefined){ return ""; }
	strLen=this.length;
	tLen=0;
	for (var i = 0; i < strLen; i++){
		charCode=this.charCodeAt(i);
		if (charCode < 0 || charCode > 255) {
			tLen +=  2;
		} else {
			tLen++;
		}
		if (tLen>=outputLen){ return this.substr(0,i) + "..."; }
	}
	return this;
}

// Trim String -----------------------------------------------
String.prototype.trim = function(){
	// Trim Extra Spaces & Newlines
	if (this == undefined){ return ""; }
	var str = this;
	str=str.replace(/(^\s*|\s*$)/g,"");
	str=str.replace(/(\r*\n){3,}/g,"\n\n");
	str=str.replace(/\r/g,"");

	return str;
}

// Convert String to RegExp compatible -----------------------------------------------
String.prototype.stringToRegExp = function() {
	if (this == undefined){ return ""; }
	var str = this;
	str=str.replace(/\\/g,"\\");
	str=str.replace(/\^/g,"\\^");
	str=str.replace(/\*/g,"\\*");
	str=str.replace(/\?/g,"\\?");
	str=str.replace(/\ + /g,"\\ + ");
	str=str.replace(/\./g,"\\.");
	str=str.replace(/\|/g,"\\|");
	str=str.replace(/\[/g,"\\[");
	str=str.replace(/\]/g,"\\]");
	str=str.replace(/\(/g,"\\(");
	str=str.replace(/\)/g,"\\)");
	str=str.replace(/\{/g,"\\{");
	str=str.replace(/\}/g,"\\}");
	return str;
}

// Highlight String -----------------------------------------------
String.prototype.highlight = function(arrKeywords){
	if (this == undefined || arrKeywords == undefined){ return ""; }

	// Generate Keyword RegExp String - We need to duplicate the original keyword array here
	var str = this;
	var reStr=arrKeywords.join("$,$");
	reStr=reStr.split("$,$");
	for (var i = 0; i < reStr.length; i++){
		if (reStr[i].lengthW()<3){
			reStr.splice(i,1);
			i--;
		} else {
			reStr[i]=reStr[i].stringToRegExp();
		}
	}
	reStr=new RegExp("(" + reStr + ")","ig");

	var re=new RegExp("(\>|^)(.*?)(\<|$)","igm");
	while ((arrMatch = re.exec(str))  !=  null){
		var newStr=arrMatch[1] + arrMatch[2].replace(reStr,'<span class="highlight">' + "$1" + '</span>') + arrMatch[3];
		str=str.replace(arrMatch[0],newStr);
		re.lastIndex += newStr.length-arrMatch[0].length;
	}

	return str;
}

// Trim HTML Tags --------------------------------------------
function trimHTML (str){
	if (str == undefined){ return ""; }
	str=str.replace(/\<[^\<\>] + \>/g,"");
	str=str.replace(/ +/g," ");

	return str;
}

// Clean HTML Tags --------------------------------------------
function cleanHTML (str){
	var re=new RegExp("\<scr" + "ipt([^\<\>]+)\>","ig");
	str=str.replace(re,"&lt;script$1&gt;");
	re=new RegExp("\<\/scr" + "ipt\>","ig");
	str=str.replace(re,"&lt;/script&gt;");
	delete re;

	str=str.replace(/\<iframe(\/| \/|)\>/ig,"&lt;iframe$1&gt;");
	str=str.replace(/\<\/iframe\>/ig,"&lt;/iframe&gt;");

	str=str.replace(/\<br(\/| \/|)\>/ig,"<br/>");

	return str;
}

// Close HTML Tags --------------------------------------------
function closeHTML (str){
	var arrTags=["p","div","span","table","ul","font","b","u","i","h1","h2","h3","h4","h5","h6"];

	for (var i = 0; i < arrTags.length; i++){
		var intOpen=0;
		var intClose=0;

		var	re=new RegExp("\\<" + arrTags[i] + "( [^\\<\\>] + |)\\>","ig");
		var arrMatch=str.match(re);
		if (arrMatch != null) intOpen=arrMatch.length;

		re=new RegExp("\\<\\/" + arrTags[i] + "\\>","ig");
		arrMatch=str.match(re);
		if (arrMatch != null) intClose=arrMatch.length;

		for (var j = 0; j < intOpen-intClose; j++){
			str += "</" + arrTags[i] + ">";
		}
	}

	return str;
}

// Close UBB Tags --------------------------------------------
function closeUBB (str){
	var arrTags=["code","quote","list","color","align","font","size","b"];

	for (var i = 0; i < arrTags.length; i++){
		var intOpen=0;
		var intClose=0;

		var	re=new RegExp("\\[" + arrTags[i] + "(=[^\\[\\]] + |)\\]","ig");
		var arrMatch=str.match(re);
		if (arrMatch != null) intOpen=arrMatch.length;

		re=new RegExp("\\[\\/" + arrTags[i] + "\\]","ig");
		arrMatch=str.match(re);
		if (arrMatch != null) intClose=arrMatch.length;

		for (var j = 0; j < intOpen-intClose; j++){
			str += "[/" + arrTags[i] + "]";
		}
	}

	return str;
}

// Check String for SQL Query --------------------------------
function checkStr (str){
	str=str.replace(/\'/g,"''");
	str=str.replace(/\r/g,"");
	str=str.replace(/(wh)(ere)/ig,"$1' + '$2");

	return str;
}

// Check Int -------------------------------------------------
// Convert String to Int
function checkInt (intStr){
	if (!intStr){ return 0; }
	intStr=parseInt(intStr,10);
	if (isNaN(intStr)){ return 0; }

	return intStr;
}

// Convert Int to Bool
function checkBool (str) {
	if (!str) return false;
	if (str == true) return true;
	str = parseInt(str, 10);
	return str == 1? true: false;
}

// Check Username -------------------------------------------
function checkUsername (str){
	if (typeof(str) != "string"){ return false; }
	if (lengthW(str)<3 || str.length>24){ return false; }
	if (str.search(/[^\w\u3400-\u4DBF\u4E00-\u9FAF]/) != -1){
		return false;
	}
	return true;
}

// Check Password -------------------------------------------
function checkPassword (str){
	if (str == undefined){ return false; }

	if (str.length<6 || str.length>16){ return false; }
	if (str.search(/[^\x20-\x7e]/g) != -1){
		return false;
	}
	return true;
}

// Check Email ----------------------------------------------
function checkEmail (str){
	if (str == undefined){ return false; }
	if (str.length<6 || str.length>50){ return false; }
	var m;
	if ((m=str.match(/[\w\[\]\@\(\)\.] + \. + [A-Za-z]{2,4}/g))  !=  null){
		if (m[0] == str) return true;
	}
	return false;
}

// Check URL ----------------------------------------------
function checkURL (str){
	str = str.replace(/document\.cookie/ig, "document cookie");
	str = str.replace(/document\.write/ig, "document write");
	str = str.replace(/javascript:/ig, "javascript ");
	str = str.replace(/jscript:/ig, "jscript ");
	str = str.replace(/vbscript:/ig, "vbscript ");
	str = str.replace(/\<|\>/ig, " ");
	return str;
}

// Word Filter ----------------------------------------------
function wordFilter (str){
	if (str == undefined){ return false; }
	if (str.length < 3){ return str; }
	for (var i = 0; i < theCache.wordFilter.length; i++){
		with(theCache.wordFilter[i]){
			var ctext= isRegExp? text:stringToRegExp(text);
			ctext=new RegExp(ctext,"gi");
			if (mode == 0){
				str=str.replace(ctext,replace);
			} else {
				if (str.search(ctext) > -1){
					return false;
				}
			}
		}
	}
	return str;
}

// Random String Generator ----------------------------------
function randomStr (intLength, strSeed){
	if (strSeed == undefined) {
		strSeed = "abcdefghijklmnopqrstuvwxyz1234567890";
	}
	var seedLength=strSeed.length;
	var str="";
	for (var i = 0; i < intLength;){
		var pos = Math.round((Math.random() * seedLength));
		if (pos >= 0 && pos < seedLength){
			str += strSeed.charAt(pos);
			i++;
		}
	}
	return str;
}

// DateTime Output function ---------------------------------
// YY: Full Year                yy: Short Year
// MM: Numberic Month with 0    mm: Numberic Month
//  M: Month Name                m: Short Month Name
// DD: Numberic Date with 0     dd: Numberic Date
//  W: Weekday Name              w: Short Weekday Name
// hh: Numberic Hour with 0     HH: Numberic Hour
//  h: 12 Hour Format with 0     H: 12 Hour Format
// ii: Numberic Minute with 0   II: Numberic Minute
// ss: Numberic Second with 0   SS: Numberic Second
//  Z: Full TimeZone Offset      z: Short TimeZone Offset
// ZZ: Full  Offset with "Z"    zz: Short Offset with "Z"
function getDateTimeString (strFormat, objDate, bEnglishNames){
	var t=[];
	t["weekday_0"]="Sunday";
	t["weekday_1"]="Monday";
	t["weekday_2"]="Tuesday";
	t["weekday_3"]="Wednesday";
	t["weekday_4"]="Thursday";
	t["weekday_5"]="Friday";
	t["weekday_6"]="Saturday";
	t["weekday_abbr_0"]="Sun";
	t["weekday_abbr_1"]="Mon";
	t["weekday_abbr_2"]="Tue";
	t["weekday_abbr_3"]="Wed";
	t["weekday_abbr_4"]="Thu";
	t["weekday_abbr_5"]="Fri";
	t["weekday_abbr_6"]="Sat";
	t["month_1"]="January";
	t["month_2"]="February";
	t["month_3"]="March";
	t["month_4"]="April";
	t["month_5"]="May";
	t["month_6"]="June";
	t["month_7"]="July";
	t["month_8"]="August";
	t["month_9"]="September";
	t["month_10"]="October";
	t["month_11"]="November";
	t["month_12"]="December";
	t["month_abbr_1"]="Jan";
	t["month_abbr_2"]="Feb";
	t["month_abbr_3"]="Mar";
	t["month_abbr_4"]="Apr";
	t["month_abbr_5"]="May";
	t["month_abbr_6"]="Jun";
	t["month_abbr_7"]="Jul";
	t["month_abbr_8"]="Aug";
	t["month_abbr_9"]="Sep";
	t["month_abbr_10"]="Oct";
	t["month_abbr_11"]="Nov";
	t["month_abbr_12"]="Dec";

	if (objDate == undefined){
		objDate = new Date();
	} else {
		objDate = new Date(objDate);
	}
	if (strFormat == undefined || strFormat == ""){
		strFormat="YY-MM-DD hh:ii:ss";
	}
	var tYear=objDate.getFullYear();
	var tMonth=objDate.getMonth() + 1;
	var tDate=objDate.getDate();
	var tDay=objDate.getDay();
	var tHour=objDate.getHours();
	var tHour12= tHour>12? tHour-12:tHour;
	var tMinute=objDate.getMinutes();
	var tSecond=objDate.getSeconds();
	var tAMPM= tHour>12? "PM":"AM";
	var tZone=objDate.getTimezoneOffset();
	if (tZone == 0){
		tZone="Z";
	} else {
		tZone = Math.abs(Math.round(tZone/60));
		tZone = (objDate.getTimezoneOffset() <0 ? "-":" + ") + (tZone<10? "0" + tZone:tZone);
	}

	// Year
	strFormat=strFormat.replace(/([^\\]|^)YY/g, "$1" + tYear);
	strFormat=strFormat.replace(/([^\\]|^)yy/g, "$1" + tYear.toString().substr(0,2));
	// Month
	if (tMonth<10){
		strFormat=strFormat.replace(/([^\\]|^)MM/g,"$1" + "0" + tMonth);
	} else {
		strFormat=strFormat.replace(/([^\\]|^)MM/g,"$1" + tMonth);
	}
	strFormat=strFormat.replace(/([^\\]|^)mm/g,"$1" + tMonth);
	// Date
	if (tDate<10){
		strFormat=strFormat.replace(/([^\\]|^)DD/g,"$1" + "0" + tDate);
	} else {
		strFormat=strFormat.replace(/([^\\]|^)DD/g,"$1" + tDate);
	}
	strFormat=strFormat.replace(/([^\\]|^)dd/g,"$1" + tDate);
	// Hour
	if (tHour<10){
		strFormat=strFormat.replace(/([^\\]|^)hh/g,"$1" + "0" + tHour);
	} else {
		strFormat=strFormat.replace(/([^\\]|^)hh/g,"$1" + tHour);
	}
	strFormat=strFormat.replace(/([^\\]|^)HH/g,"$1" + tHour);
	strFormat=strFormat.replace(/([^\\]|^)H/g,"$1" + tHour12);
	strFormat=strFormat.replace(/([^\\]|^)h/g,"$1" + (tHour12<10? "0" + tHour12:tHour12));
	// Minute
	if (tMinute<10){
		strFormat=strFormat.replace(/([^\\]|^)ii/g,"$1" + "0" + tMinute);
	} else {
		strFormat=strFormat.replace(/([^\\]|^)ii/g,"$1" + tMinute);
	}
	strFormat=strFormat.replace(/([^\\]|^)II/g,"$1" + tMinute);
	// second
	if (tSecond<10){
		strFormat=strFormat.replace(/([^\\]|^)ss/g,"$1" + "0" + tSecond);
	} else {
		strFormat=strFormat.replace(/([^\\]|^)ss/g,"$1" + tSecond);
	}
	strFormat=strFormat.replace(/([^\\]|^)SS/g,"$1" + tSecond);
	// AM PM
	strFormat=strFormat.replace(/([^\\]|^)A/g,"$1" + tAMPM);
	strFormat=strFormat.replace(/([^\\]|^)a/g,"$1" + tAMPM.toLowerCase());
	// Time Zone Offset
	strFormat=strFormat.replace(/([^\\]|^)Z/g,"$1" + tZone + "00");
	strFormat=strFormat.replace(/([^\\]|^)z/g,"$1" + tZone);
	// Month & Weekday Names
	if (bEnglishNames){
		strFormat=strFormat.replace(/([^\w]|^)M([^\w]|$)/g,"$1" + t["month_" + tMonth] + "$2");
		strFormat=strFormat.replace(/([^\w]|^)m([^\w]|$)/g,"$1" + t["month_abbr_" + tMonth] + "$2");
		strFormat=strFormat.replace(/([^\w]|^)W([^\w]|$)/g,"$1" + t["weekday_" + tDay] + "$2");
		strFormat=strFormat.replace(/([^\w]|^)w([^\w]|$)/g,"$1" + t["weekday_abbr_" + tDay] + "$2");
	} else {
		strFormat=strFormat.replace(/([^\w]|^)M([^\w]|$)/g,"$1" + getLang("month_" + tMonth) + "$2");
		strFormat=strFormat.replace(/([^\w]|^)m([^\w]|$)/g,"$1" + getLang("month_abbr_" + tMonth) + "$2");
		strFormat=strFormat.replace(/([^\w]|^)W([^\w]|$)/g,"$1" + getLang("weekday_" + tDay) + "$2");
		strFormat=strFormat.replace(/([^\w]|^)w([^\w]|$)/g,"$1" + getLang("weekday_abbr_" + tDay) + "$2");
	}

	return strFormat;
}

// Generate Page Links -------------------------------------------------
function generatePageLinks (intEntryCount, intPageSize, intCurrentPage, intShowPages, urlPrefix, urlSuffix){
	var maxPage=Math.floor((intEntryCount-1)/intPageSize) + 1;
	var output="";
	urlPrefix +=  urlPrefix == "?"? "":"&amp;";
	if (urlSuffix == undefined) urlSuffix="";

	//intShowPages=(intShowPages%2 == 1)? intShowPages + 1 : intShowPages; // Should be Even Number

	// Calculate Page Bounds
	var prevBound=intCurrentPage-Math.floor(intShowPages/2);
	var nextBound=intCurrentPage + Math.floor(intShowPages/2);
	if (prevBound <= 0){
		prevBound = 1;
		nextBound = intShowPages;
	}
	if (nextBound > maxPage){
		nextBound = maxPage;
		prevBound = maxPage-intShowPages;
	}
	if (prevBound <= 0) prevBound = 1;

	if (maxPage == 1){
		output="<span class=\"pagelink-current\"> 1 </span>";
	} else {
		// First Page Link
		if (prevBound>1) output += "<a href=\"" + urlPrefix + "page=1" + urlSuffix +  "\"> &lt;&lt; </a> | \n";
		// Previous Page Link
		if (intCurrentPage>1) output += "<a href=\"" + urlPrefix + "page=" + (intCurrentPage-1) + urlSuffix + "\"> &lt; </a> | \n";
		// Process Main Portion
		for (var i = prevBound; i <= nextBound; i++){
			if (intCurrentPage == i){
				output += "<span class=\"pagelink-current\">" + i +  "</span> | \n";
			} else if (i <= maxPage) {
				output += "<a href=\"" + urlPrefix + "page=" + i + urlSuffix  + "\"> " + i + " </a> | \n";
			}
		}
		// Next Page Link
		if (intCurrentPage<maxPage) output += "<a href=\"" + urlPrefix + "page=" + (intCurrentPage + 1) + urlSuffix  + "\"> &gt; </a>\n";
		// Last Page Link
		if (nextBound<maxPage) output += " | <a href=\"" + urlPrefix + "page=" + maxPage + urlSuffix  + "\"> &gt;&gt; </a>\n";
	}
	return output;
}

// Check server object
checkServerObject = function(strObj) {
  try {
    var obj = new ActiveXObject(strObj);
  }	catch(e) {
    return false;
  }
  delete obj;
  return true;
}

function checkEmptyInputs() {
	if (arguments.length > 0) {
		var emptyInputs = [];
		for (var i = 0; i < arguments.length; i++) {
			if (input[i] == "") emptyInputs.push(i);
		}
		return emptyInputs;
	}
}

function getSession(strName) {
	return Session(theSite.nameSpace + strName);
}
function setSession(strName, strValue) {
	Session(theSite.nameSpace + strName) = strValue;
}
function removeSession(strName) {
	Session.Contents.Remove(theSite.nameSpace + strName);
}
%>
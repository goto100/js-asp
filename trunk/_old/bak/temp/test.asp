<%@LANGUAGE="JAVASCRIPT" CODEPAGE="65001"%>
<%
function PNG(width, height, depth) {
	var crcTable = getCrcTable();
	var palette = "";
	var char = {};
	this.width = width || 0;
	this.height = height || 0;
	this.depth = depth || 0;
	this.backgroundColor = 0;
	var graphs = new Array(this.width);
	for (var i = 0; i < graphs.length; i++) graphs[i] = new Array(this.height);

	function byte1(str) {
		return String.fromCharCode(str & 0xFF);
	}

	function byte4(str) {
		return String.fromCharCode((str >> 24) & 0xFF, (str >> 16) & 0xFF, (str >> 8) & 0xFF, str & 0xFF);
	}

	function getCrcTable() {
		var table = new Array(256);
		for(var c = 0, n = 0; n < 256; n++){
			c = n;
			for(var k = 0; k < 8; k++) {
				if (c & 1) c = 0xedb88320 ^ (c >>> 1);
				else c = c >>> 1;
			}
			table[n] = c;
		}
		return table;
	}

	function crc32(str){
		for (var c = 0xFFFFFFFF, n = 0; n < str.length; n++) c = crcTable[(c ^ str.charCodeAt(n)) & 0xFF] ^ (c >>> 8);
		return c ^ 0xFFFFFFFF;
	}

	function getChunk(type, str) {
		var datas = [];
		var crc = crc32(type + str);
		str = byte4(str.length) + type + str;
		str = str + byte4(crc);
		for (var i = 0; i < str.length; i++) datas.push(str.charCodeAt(i));
		return datas;
	}

	function getIDAT(width, height, backColor) {
		var data = "";
		for (var y = 0; y < height; y++) {
			data += byte1("0");
			for (var x = 0; x < width; x++) data += (graphs[x][y]? String.fromCharCode(graphs[x][y]) : String.fromCharCode(backColor));
		}
		var LEN = data.length;
		var NLEN = LEN ^ 0xFFFFFFFF;

		// Calculate Simple Adler-32 checksum
		var BASE = 65521, NMAX = 5552;
		var s1 = 1, s2 = 0, n = NMAX;
		for(var i = 0; i < LEN; i++){
			s1 += data.charCodeAt(i);
			s2 += s1;
			if ((n--) == 0) {
				s1 %= BASE;
				s2 %= BASE;
				n = NMAX;
			}
		}
		s1 %= BASE;
		s2 %= BASE;

		return getChunk("IDAT", byte1(0x78) + byte1(0xDA) + byte1(0x01) /*uncompressd lz77*/
			+ String.fromCharCode((LEN) & 0xFF, (LEN >> 8) & 0xFF, (NLEN) & 0xFF, (NLEN >> 8) & 0xFF)
			+ data + byte4((s2 << 16) | s1));
	}

	this.putPixel = function(x, y, color) {
		if (graphs[x]) graphs[x][y] = color;
	}

	this.getPixel = function(x, y) {
		return graphs[x][y];
	}

	this.addColor = function(r, g, b) {
		palette += byte1(r) + byte1(g) + byte1(b);
	}

	this.addChar = function(name, code, width, height) {
		char[name] = {code:		code,
									width:	width,
									height:	height}
	}

	this.putChar = function(name, ox, oy, color, width, height, offset) {
		var weightX = width / 10;
		var weightY = height / 10;
		for(var y = 0; y < char[name].height; y++) {
			for(var x = 0; x < char[name].width; x++) {
				for (var i = 0; i < weightX; i++) {
					for (var j = 0; j < weightY; j++) {
						if (!parseInt(char[name].code.charAt(x + y * char[name].width))) {
							this.putPixel(ox + x * weightY + j % weightY, oy + y * weightY + i, color);
						}
					}
				}
			}
		}
	}

	this.putNoise = function(n, color) {
		var x = Math.floor(Math.random() * this.width);
		var y = Math.floor(Math.random() * this.height);
	}

	this.smooth = function() {
		var x, y;
		var c0, c1, c2, c3, c4; // center, up, right, down, left
		for(x = 0; x < this.width; x++) for(y = 0; y < this.height; y++) {
			c0 = this.getPixel(x, y);
			c1 = (y > 0) ? this.getPixel(x, y - 1) : c0;
			c2 = (x < this.width) ? this.getPixel(x + 1, y) : c0;
			c3 = (y < this.height) ? this.getPixel(x, y + 1) : c0;
			c4 = (x > 0) ? this.getPixel(x - 1, y) : c0;
			this.putPixel(x, y, Math.floor((c0 * 6 + c1 + c2 + c3 + c4) / 10 + 0.5));
		}
	}

	this.output = function(str) {
		Response.Expires = -9999;
		Response.AddHeader("Pragma", "no-cache");
		Response.AddHeader("Cache-Control", "no-cache");
		Response.ContentType = "image/png";
		var chunkIHDR = getChunk("IHDR", byte4(this.width) + byte4(this.height) + byte1(this.depth) + byte1(3) + byte1(0) + byte1(0) + byte1(0));
		var chunkPLTE = getChunk("PLTE", palette);
		var chunkIDAT = getIDAT(this.width, this.height, this.backgroundColor);
		var chunkIEND = getChunk("IEND", "");
		var datas = [0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a].concat(chunkIHDR, chunkPLTE, chunkIDAT, chunkIEND);
		if (datas.length % 2 == 1) datas.push(0);
		for (var i = 0; i < datas.length - 1; i += 2) Response.BinaryWrite(String.fromCharCode(datas[i] + (datas[i + 1] << 8)));
	}
}

function PNGSCode(width, height) {
	PNG.apply(this, [width, height, 8]);

	this.addColor(0, 0, 0);
	this.addColor(255, 255, 255);
	this.addColor(0, 255, 255);
	this.addColor(255, 0, 255);
	this.addColor(255, 255, 0);
	this.addChar("0", "1110000111"
									+ "1101111011"
									+ "1101111011"
									+ "1101111011"
									+ "1101111011"
									+ "1101111011"
									+ "1101111011"
									+ "1101111011"
									+ "1101111011"
									+ "1110000111", 10, 10);
	this.addChar("1", "1111011111"
									+ "1100011111"
									+ "1111011111"
									+ "1111011111"
									+ "1111011111"
									+ "1111011111"
									+ "1111011111"
									+ "1111011111"
									+ "1111011111"
									+ "1100000111", 10, 10);
	this.addChar("2", "1110000111"
									+ "1101111011"
									+ "1101111011"
									+ "1111111011"
									+ "1111110111"
									+ "1111101111"
									+ "1111011111"
									+ "1110111111"
									+ "1101111011"
									+ "1100000011", 10, 10);
	this.addChar("3", "1110000111"
									+ "1101111011"
									+ "1101111011"
									+ "1111110111"
									+ "1111001111"
									+ "1111110111"
									+ "1111111011"
									+ "1101111011"
									+ "1101111011"
									+ "1110000111", 10, 10);
	this.addChar("4", "1111101111"
									+ "1111101111"
									+ "1111001111"
									+ "1110101111"
									+ "1101101111"
									+ "1101101111"
									+ "1100000011"
									+ "1111101111"
									+ "1111101111"
									+ "1111000011", 10, 10);
	this.addChar("5", "1100000011"
									+ "1101111111"
									+ "1101111111"
									+ "1101000111"
									+ "1100111011"
									+ "1111111011"
									+ "1111111011"
									+ "1101111011"
									+ "1101111011"
									+ "1110000111", 10, 10);
	this.addChar("6", "1111000111"
									+ "1110111011"
									+ "1101111111"
									+ "1101111111"
									+ "1101000111"
									+ "1100111011"
									+ "1101111011"
									+ "1101111011"
									+ "1101111011"
									+ "1110000111", 10, 10);
	this.addChar("7", "1100000011"
									+ "1101110111"
									+ "1101110111"
									+ "1111101111"
									+ "1111101111"
									+ "1111011111"
									+ "1111011111"
									+ "1111011111"
									+ "1111011111"
									+ "1111011111", 10, 10);
	this.addChar("8", "1110000111"
									+ "1101111011"
									+ "1101111011"
									+ "1101111011"
									+ "1110000111"
									+ "1110110111"
									+ "1101111011"
									+ "1101111011"
									+ "1101111011"
									+ "1110000111", 10, 10);
	this.addChar("9", "1110001111"
									+ "1101110111"
									+ "1101111011"
									+ "1101111011"
									+ "1101110011"
									+ "1110001011"
									+ "1111111011"
									+ "1111111011"
									+ "1101110111"
									+ "1110001111", 10, 10);
	this.addChar("A", "1111011111"
									+ "1111011111"
									+ "1110101111"
									+ "1110101111"
									+ "1110101111"
									+ "1110101111"
									+ "1100000111"
									+ "1101110111"
									+ "1101110111"
									+ "1000100011", 10, 10);
	this.addChar("B", "1000000111"
									+ "1101111011"
									+ "1101111011"
									+ "1101110111"
									+ "1100001111"
									+ "1101110111"
									+ "1101111011"
									+ "1101111011"
									+ "1101111011"
									+ "1000000111", 10, 10);
	this.addChar("C", "1110000011"
									+ "1101111011"
									+ "1011111011"
									+ "1011111111"
									+ "1011111111"
									+ "1011111111"
									+ "1011111111"
									+ "1011111011"
									+ "1101110111"
									+ "1110001111", 10, 10);
	this.addChar("D", "0000001111"
									+ "1101110111"
									+ "1101111011"
									+ "1101111011"
									+ "1101111011"
									+ "1101111011"
									+ "1101111011"
									+ "1101111011"
									+ "1101110111"
									+ "0000001111", 10, 10);
	this.addChar("E", "1000000111"
									+ "1101111011"
									+ "1101101111"
									+ "1101101111"
									+ "1100001111"
									+ "1101101111"
									+ "1101101111"
									+ "1101111111"
									+ "1101111011"
									+ "1000000111", 10, 10);
	this.addChar("F", "1000000111"
									+ "1101111011"
									+ "1101101111"
									+ "1101101111"
									+ "1100001111"
									+ "1101101111"
									+ "1101101111"
									+ "1101111111"
									+ "1101111111"
									+ "1000111111", 10, 10);
	this.backgroundColor = 0;

	this.outputSCode = function(str) {
		for (var i = 0; i < str.length; i++) this.putChar(str.charAt(i), i * 35 + 5, 2, 1, 40, 40, 4);
		this.putNoise(500, 1);
		this.output();
	}
}
var png = new PNGSCode(290, 80);
png.outputSCode("0EF1");
%>
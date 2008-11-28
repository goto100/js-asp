<%
////////////////////////////////////////////////////////////
// Class UBB
//
// Last modify: 2005/6/20
// Author: ScYui
//
// Attributes: 
// Methods: 
////////////////////////////////////////////////////////////
function UBB() {
	////////// Attributes //////////////////////////////
	// Private //////////
	var Tag; // Class Tag

	// Public //////////
	this.tags = [{"name":"strong"}];

	////////// Methods //////////////////////////////
	// Private //////////

	// Public //////////
	this.addTag = function(strName, boolCloseSelf) {
		return new UBB.Tag(strName, boolCloseSelf);
	}

	this.toHTML = function(str) {

	str = Server.HTMLEncode(str);
	for (var i = 0; i < this.tags.length; i++) {
	}
		  // str = str.replace(/^([ -~]+)$\r\n/igm, "<p lang=\"en-us\" class=\"english\">$1</p>"); // English
		  // str = str.replace(/^(.*[\u4E00-\u9FA5].*)$\r\n/igm, "<p lang=\"zh-cn\">$1</p>");
		return str;
	}
}

// Class Tag
UBB.Tag = function(strName, boolCloseSelf) {
	////////// Attributes //////////////////////////////
	// Private //////////
	var Attribute; // Class Attribute

	// Public //////////
	this.name = strName;
	this.attributes = [];
	this.closeSelf = boolCloseSelf? boolCloseSelf: 0;
	this.allValuesLength = 0;

	////////// Methods //////////////////////////////
	// Private //////////

	// Public //////////
	this.addAttribute = function(strName, objValues) {
		var attribute = {};
		attribute.name = strName;
		attribute.values = [];
		if (objValues && (objValues.constructor == String || objValues.constructor == Number)) attribute.values = [objValues];
		else if (objValues) attribute.values = objValues;

		this.attributes.push(attribute);
		this.allValuesLength += attribute.values.length;
	}

	this.getExample = function() {
		var str = "";
		str += "&lt;" + this.name;

		if (this.attributes) {
			for (var j = 0; j < this.attributes.length; j++) {
				str += " " + this.attributes[j].name + "=\"";

				if (this.attributes[j].values) {

					for (var k = 0; k < this.attributes[j].values.length; k++) {
						str += this.attributes[j].values[k] + "|";
					}
					str = str.slice(0, -1);

				} else {
					str += "Anything";
				}

				str += "\"";
			}
		}

		str += this.closeSelf? " \/&gt;": "&gt;&lt;\/" + this.name + "&gt;";
		return str;
	}
}

var ubb = new UBB();

var table = ubb.addTag("table");
table.addAttribute("description");

var tr = ubb.addTag("tr");

var td = ubb.addTag("td");
var colspan = td.addAttribute("colspan");
var rowspan = td.addAttribute("rowspan");
var scope = td.addAttribute("scope");

var ubbImg = ubb.addTag("ubb:img", 1);
ubbImg.addAttribute("width");
ubbImg.addAttribute("height");
ubbImg.addAttribute("maxwidth");
ubbImg.addAttribute("maxheight");
ubbImg.addAttribute("alt");
ubbImg.addAttribute("title");

var ubbQuote = ubb.addTag("ubb:quote");
ubbQuote.addAttribute("cite")

var ubbRun = ubb.addTag("ubb:run");

var ubbCode = ubb.addTag("ubb:code");
ubbCode.addAttribute("type", ["javascript", "vbscript", "html"]);

var strong = ubb.addTag("strong");
var em = ubb.addTag("em");
var strike = ubb.addTag("strike");
var sup = ubb.addTag("sup");
var sub = ubb.addTag("sub");
var ul = ubb.addTag("ul");
ul.addAttribute("type", ["disc", "circle", "square", "decimal", "lower-roman", "upper-roman", "lower-alpha", "upper-alpha", "none", "decimal-leading-zero", "lower-greek", "lower-latin", "upper-latin", "hebrew", "armenian", "georgian", "cjk-ideographic", "hiragana", "katakana", "hiragana-iroha", "katakana-iroha", "inherit"]);
var ol = ubb.addTag("ol");
ol.addAttribute("type", ["disc", "circle", "square", "decimal", "lower-roman", "upper-roman", "lower-alpha", "upper-alpha", "none", "decimal-leading-zero", "lower-greek", "lower-latin", "upper-latin", "hebrew", "armenian", "georgian", "cjk-ideographic", "hiragana", "katakana", "hiragana-iroha", "katakana-iroha", "inherit"]);
var li = ubb.addTag("li");
%>

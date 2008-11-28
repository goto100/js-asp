<%
//////////////////////////////////////////////////
// Class Name: XMLDom
// Author: ScYui
// Last Modify: 2005/9/23
//////////////////////////////////////////////////

function XMLDom(aysnc) {
	////////// Attributes //////////////////////////////
	// Private //////////
	var dom = XMLDom.create(aysnc);

	// Class Element
	function Element(name) {
		this.dom = dom.createElement(name);

		// Add a attribute
		this.addAttribute = function(name, value) {
			this.dom.setAttribute(name, value);
		}

		// Add a child element
		this.addChild = function(name, attributes, value) {
			var element = new Element(name);
			this.dom.appendChild(element.dom);

			if (attributes != undefined) {
				var e = attributes.getExpandoNames();
				for (var i = 0; i < e.length; i++) {
					element.addAttribute(e[i], attributes[e[i]]);
				}
			}

			if (value != undefined) {
				element.setContent(value);
			}

			return element;
		}

		// Set content
		this.setContent = function(text) {
			if (typeof(text) == "date") this.dom.text = text;
			else this.dom.text = text.toString();
		}
	}

	// Public //////////
	this.documentElement = dom.documentElement;

	////////// Methods //////////////////////////////
	// Private //////////

	// Public //////////

	// Set root element
	this.setRoot = function(str) {
		var element = new Element(str);
		dom.documentElement = element.dom;

		this.documentElement = dom.documentElement;
		return element;
	}

	// Transform xml with xsl file
	this.transformNode = function(obj) {
		return dom.transformNode(obj);
	}

	// Get dom
	this.getDom = function() {
		return dom;
	}
}

XMLDom.create = function(aysnc) {
	try {
		var xmlDom = new ActiveXObject("MSXML2.DomDocument");
	} catch(e) {
		try {
			var xmlDom = new ActiveXObject("MSXML.DomDocument");
		} catch(e) {
			try {
				var xmlDom = new ActiveXObject("Microsoft.XMLDom");
			} catch(e) {
				outputErrorMsg("Can't create XML Dom, you shoule have Microsoft.XMLDom object");
			}
		}
	}
	if (aysnc == true) xmlDom.async = true;
	else xmlDom.async = false;

	return xmlDom;
}

%>

<%
//////////////////////////////////////////////////
// Class Name: XMLDom
// Author: ScYui
// Last Modify: 2005/9/23
//////////////////////////////////////////////////

function XMLDom(bAysnc) {
	////////// Attributes //////////////////////////////
	// Private //////////
	var dom = XMLDom.create(bAysnc);

	// Class Element
	function Element(str) {
		this.dom = dom.createElement(str);

		// Add a attribute
		this.addAttribute = function(strName, strValue) {
			this.dom.setAttribute(strName, strValue.toString());
		}

		// Add a child element
		this.addChild = function(str, objAttributes, strValue) {
			var element = new Element(str);
			this.dom.appendChild(element.dom);

			if (objAttributes) {
				var e = objAttributes.getExpandoNames();
				for (var i = 0; i < e.length; i++) {
					element.addAttribute(e[i], objAttributes[e[i]]);
				}
			}

			if (strValue) {
				element.setContent(strValue);
			}

			return element;
		}

		// Set content
		this.setContent = function(obj) {
			this.dom.text = obj.toString();
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

XMLDom.create = function(bAsync) {
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
	if (bAsync == true) xmlDom.async = true;
	else xmlDom.async = false;

	return xmlDom;
}

%>

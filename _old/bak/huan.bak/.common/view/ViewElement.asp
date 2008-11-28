<script language="javascript" runat="server">
function PageElement(name) {
	this.xmlDom = null;
	this.dom = null;

	function checkValue(value) {
		switch (value.constructor) {
			case Date: value = value.format();
		}
		return value;
	}

	this.setDomSource = function(xmlDom) {
		this.xmlDom = xmlDom;
		this.dom = this.xmlDom.createElement(name);
	}

	this.addAttribute = function(name, value) {
		if (value != null) this.dom.setAttribute(name, checkValue(value));
	}

	this.setContent = function(content) {
		this.dom.text = content;
	}

	this.appendChild = function(element) {
		element.setDomSource(this.xmlDom);
		this.dom.appendChild(element.dom);
	}

	this.addChild = function(name, value, attribute) {
		var element = new ViewElement(name);
		element.setDomSource(this.xmlDom);

		if (attribute) {
			for (var i in attribute) if (attribute.hasOwnProperty(i)) element.addAttribute(i, attribute[i]);
		}
		if (value && value.constructor == Object) {
			for (var i in value) if (value.hasOwnProperty(i)) element.addChild(i, value[i]);
		} else if (value != null) element.setContent(checkValue(value));

		this.dom.appendChild(element.dom);

		return element;
	}

	this.addCDATAChild = function(content) {
		var cdata = this.xmlDom.createCDATASection(content);
		this.dom.appendChild(cdata);
	}

	this.addXMLChild = function(name, content) {
		var xml = "<" + name + ">";
		xml += content;
		xml += "</" + name + ">";
		var dom = new XMLDom;
		dom.loadXML(xml);
		if (dom.parseError.errorCode) {
			writeln(dom.parseError.reason);
			write(xml);
			Response.End();
		} else this.dom.appendChild(dom.documentElement);
		delete dom;
	}
}
</script>
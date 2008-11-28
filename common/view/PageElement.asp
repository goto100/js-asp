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
		var element = new PageElement(name);
		element.setDomSource(this.xmlDom);

		if (attribute) {
			var e = attribute.getExpandoNames();
			for (var i = 0; i < e.length; i++) element.addAttribute(e[i], attribute[e[i]]);
		}
		if (value && value.constructor == Object) {
			var e = value.getExpandoNames();
			for (var i = 0; i < e.length; i++) element.addChild(e[i], value[e[i]]);
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
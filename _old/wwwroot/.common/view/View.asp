<script language="javascript" runat="server">
function View()
{
	ViewElement.call(this);

	try
	{
		var xmlDom = new XMLDom();
	}
	catch (e)
	{
		throw e;
	}
	var contentType = View.XML;
	var xslFile;

	this.setRoot = function(name)
	{
		this.dom = xmlDom.createElement(name);
		xmlDom.documentElement = this.dom;
	}

	this.output = function()
	{
		var result = "";
		if (contentType == View.XML)
		{
			Response.ContentType = "text/xml";
			result = "<?xml version=\"1.0\" encoding=\"" + Response.Charset +"\"?>";
			if (xslFile) result += "\r\n<?xml-stylesheet type=\"text/xsl\" href=\"" + xslFile + "\"?>";
			result += "\r\n" + xmlDom.documentElement.xml;
		} 
		else if (contentType == View.HTML)
		{
			xmlDom.loadXML(xmlDom.xml); // Fuck Microsoft!
			Response.ContentType = "text/html";
			var domTemplate = new XMLDom();
			try
			{
				domTemplate.load(Server.MapPath(xslFile));
				if (domTemplate.parseError.errorCode != 0) 
					throw 0;
			}
			catch(e)
			{
				outputException(e);
			}

			result = xmlDom.transformNode(domTemplate);
		}
		Response.Write(result);
	}

	function ViewElement(name)
	{
		if (name)
			this.dom = xmlDom.createElement(name);

		function checkValue(value) {
			switch (value.constructor) {
				case Date: value = value.format();
			}
			return value;
		}

		this.addAttribute = function(name, value) {
			if (value != null) this.dom.setAttribute(name, checkValue(value));
		}
	
		this.setContent = function(content) {
			this.dom.text = content;
		}

		this.addChild = function(name, value, attribute)
		{
			var element = new ViewElement(name);
	
			if (attribute)
				for (var i in attribute)
					if (attribute.hasOwnProperty(i))
						element.addAttribute(i, attribute[i]);
			if (value && value.constructor == Object)
				for (var i in value)
					if (value.hasOwnProperty(i))
						element.addChild(i, value[i]);
			else if (value != null)
				element.setContent(checkValue(value));
	
			this.dom.appendChild(element.dom);
	
			return element;
		}

		this.setChild = function(child)
		{
			if (typeof child == "string")
				this.setContent(child);
			else
				for (var i in child)
					if (child.hasOwnProperty(i))
					{
						if (i.charAt(0) == "$")
							this.addAttribute(i.slice(1, i.length), child[i]);
						else
						{
							var ele = this.addChild(i);
							ele.setChild(child[i]);
						}
					}
		}
	}
}
View.XML = 1;
View.HTML = 2;
</script>
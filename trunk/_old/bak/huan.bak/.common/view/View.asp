<script language="javascript" runat="server">
function View(rootElement) {
	var dom = new XMLDom;
	var xslFile = "";

	this.msg = null;
	this.content = null;
	this.contentType = View.XML;
	this.rootPath = "";
	this.visitor = null;

	// Output message on halt on
	function outputException(err) {
		Response.Write(err);
		Response.End();
	}

	this.setXslFile = function(aXslFile)
	{
		xslFile = aXslFile;
	}

	this.setRoot = function(element) {
		if (element.constructor == String) {
			element = new ViewElement(element);
			element.setDomSource(dom);
		}
		this.content = element;
		this.content.setDomSource(dom);

		dom.documentElement = this.content.dom;
	}

	// Output page
	this.output = function() {
		this.content.addAttribute("xmlns:page", "huan:page");
		this.content.addAttribute("page:rootPath", this.rootPath);
		this.content.addAttribute("page:msg", this.msg);
		this.content.addAttribute("page:executeCount", DBAccess.executeCount);
		this.content.addAttribute("page:runtime", new Date - START_TIME);
		var elePageUser = this.content.addChild("page:visitor", null, {id: this.visitor.id, loggedIn: this.visitor.loggedIn});
		elePageUser.addChild("page:nickname", this.visitor.nickname);
		elePageUser.addChild("page:group", this.visitor.group.name, {id: this.visitor.group.id});

		var result = "";
		if (this.contentType == View.XML) {
			Response.ContentType = "text/xml";
			result = "<?xml version=\"1.0\" encoding=\"" + Response.Charset +"\"?>";
			if (xslFile) result += "\r\n<?xml-stylesheet type=\"text/xsl\" href=\"" + xslFile + "\"?>";
			result += "\r\n" + dom.documentElement.xml;
		} else {
			dom.loadXML(dom.xml); // Fuck Microsoft!
			Response.ContentType = "text/html";
			var domTemplate = new XMLDom;
			try {
				domTemplate.load(Server.MapPath(xslFile));
				if (domTemplate.parseError.errorCode != 0) throw new Error(0, "Read template file ERROR.");
			} catch(e) {
				outputException(e);
			}

			result = dom.transformNode(domTemplate);
		}
		Response.Write(result);
	}

	// Build page
	this.build = function(path) {
		this.content.addAttribute("xmlns:page", "huan:page");
		this.content.addAttribute("page:rootPath", this.rootPath);

		var result = "";
		if (this.contentType == View.XML) {
			Response.ContentType = "text/xml";
			result = "<?xml version=\"1.0\" encoding=\"" + Response.Charset +"\"?>";
			if (xslFile) result += "\r\n<?xml-stylesheet type=\"text/xsl\" href=\"" + xslFile + "\"?>";
			result += "\r\n" + dom.documentElement.xml;
		} else if (this.contentType == View.HTML) {
			Response.ContentType = "text/html";
			var domTemplate = new XMLDom;
			try {
				domTemplate.load(Server.MapPath(xslFile));
				if (domTemplate.parseError.errorCode != 0) throw new Error(0, "Read template file ERROR.");
			} catch(e) {
				outputException(e);
			}

			result = dom.transformNode(domTemplate);
		}
		var stream = new ActiveXObject("ADODB.Stream");
		with(stream) {
			Type = 2;
			Mode = 3;
			Open();
			Charset = Response.Charset;
			Position = Size;
			WriteText = result;
			SaveToFile(Server.MapPath(path), 2);
			Close();
		}
		delete stream;
	}

	if (rootElement) this.setRoot(rootElement);

	var xslFile = "";
}
View.XML = 1;
View.HTML = 2;
</script>
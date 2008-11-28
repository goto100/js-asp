<script language="javascript" runat="server">
function Page(rootElement) {
	var dom = new XMLDom;

	this.xslFile = "";
	this.msg = null;
	this.content = null;
	this.contentType = "xml";
	this.rootPath = "";
	this.visitor = null;

	// Output message on halt on
	function outputErrorMsg(err) {
		Response.Write(err);
		Response.End();
	}

	this.setRoot = function(element) {
		if (element.constructor == String) {
			element = new PageElement(element);
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
		if (this.contentType == "xml") {
			Response.ContentType = "text/xml";
			result = "<?xml version=\"1.0\" encoding=\"" + Response.Charset +"\"?>";
			if (this.xslFile) result += "\r\n<?xml-stylesheet type=\"text/xsl\" href=\"" + this.xslFile + "\"?>";
			result += "\r\n" + dom.documentElement.xml;
		} else {
			dom.loadXML(dom.xml); // Fuck Microsoft!
			Response.ContentType = "text/html";
			var domTemplate = new XMLDom;
			try {
				domTemplate.load(Server.MapPath(this.xslFile));
				if (domTemplate.parseError.errorCode != 0) throw new Error(0, "Read template file ERROR.");
			} catch(e) {
				outputErrorMsg(e);
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
		if (this.contentType == "xml") {
			Response.ContentType = "text/xml";
			result = "<?xml version=\"1.0\" encoding=\"" + Response.Charset +"\"?>";
			if (this.xslFile) result += "\r\n<?xml-stylesheet type=\"text/xsl\" href=\"" + this.xslFile + "\"?>";
			result += "\r\n" + dom.documentElement.xml;
		} else if (this.contentType == "html") {
			Response.ContentType = "text/html";
			var domTemplate = new XMLDom;
			try {
				domTemplate.load(Server.MapPath(this.xslFile));
				if (domTemplate.parseError.errorCode != 0) throw new Error(0, "Read template file ERROR.");
			} catch(e) {
				outputErrorMsg(e);
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
}
</script>
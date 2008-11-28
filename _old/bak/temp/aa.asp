<%@LANGUAGE="JAVASCRIPT" CODEPAGE="65001"%>
<%
var dom = new ActiveXObject("MSXML2.DomDocument.3.0");
var eleRoot = dom.createElement("root");
eleRoot.setAttribute("xmlns:test", "test");
var eleTestTest = dom.createNode(1, "test", "test");
eleTestTest.text = "test";
eleRoot.appendChild(eleTestTest);
dom.documentElement = eleRoot;
var domTemplate = new ActiveXObject("MSXML2.DomDocument.3.0");
domTemplate.load(Server.MapPath("aa.xsl"));
var result = dom.transformNode(domTemplate);
Response.Write(result);
%>
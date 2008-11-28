<!--#include file="controller/Action.asp" -->
<!--#include file="controller/Controller.asp" -->
<!--#include file="controller/FormAction.asp" -->
<!--#include file="controller/SubmitAction.asp" -->

<!--#include file="view/View.asp" -->
<!--#include file="view/FormView.asp" -->
<script language="javascript" runat="server">
/**
Simple write
*/
function write(str)
{
	Response.Write(str);
}

/**
Simple write line
*/
function writeln(str)
{
	Response.Write(str + "<br />");
}

/**
Debug
*/
function test()
{
	write("!");
}

/**
XMLDom
*/
function XMLDom()
{
	try
	{
		var xmlDom = new ActiveXObject("MSXML2.DomDocument");
	}
	catch(e)
	{
		try
		{
			var xmlDom = new ActiveXObject("MSXML.DomDocument");
		}
		catch(e)
		{
			try
			{
				var xmlDom = new ActiveXObject("Microsoft.XMLDom");
			}
			catch(e)
			{
				throw 0;
			}
		}
	}
	xmlDom.async = false;

	return xmlDom;
}
</script>
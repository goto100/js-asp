<!--#include file="../src/mvc.asp" -->
<!--#include file="lib/business/Site.asp" -->
<script language="javascript" runat="server">

Response.Buffer = true;
Server.ScriptTimeOut = 90;

Session.LCID = 2048;
// Session.LCID = 2057;

Session.CodePage = 65001;
// Session.CodePage = 936;

 Response.Charset = "utf-8";
//Response.Charset = "gb2312";


MAIN_DB_PATH = Server.MapPath("/js-asp/test/db/huan.mdb");
NAME_SPACE = "test";

var site = new Site();
site.load();

var controller = new Controller();
</script>

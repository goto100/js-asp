<!--#include file="../src/mvc.asp" -->
<!--#include file="lib/business/Site.asp" -->
<script language="javascript" runat="server">

MAIN_DB_PATH = Server.MapPath("/js-asp/test/db/huan.mdb");
NAME_SPACE = "test";

var site = new Site();
site.load();

var controller = new Controller();
</script>

<%@LANGUAGE="JAVASCRIPT" CODEPAGE="65001"%>
<script language="javascript" runat="server">
var DEBUG = true;
</script>
<!--#include file="common.asp"-->
<!--#include file="lib/web/UserListAction.asp"-->
<script language="javascript" runat="server">
/*
controller.addActionClass(SaveUserAction);

controller.addActionClass(UpdateUserAction);
controller.addActionClass(DeleteUserAction);
controller.addActionClass(UserAction);
*/

controller.addActionClass(UserListAction, Controller.LIST_ACTION);
controller.addActionClass(EditUserAction, Controller.EDIT_ACTION);
controller.addActionClass(AddUserAction, Controller.ADD_ACTION);
controller.execute();
</script>

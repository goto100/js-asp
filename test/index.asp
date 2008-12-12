<%@LANGUAGE="JAVASCRIPT" CODEPAGE="65001"%>
<!--#include file="common.asp"-->
<!--#include file="lib/web/UserListAction.asp"-->
<script language="javascript" runat="server">
/*
controller.addActionClass(SaveUserAction);

controller.addActionClass(UpdateUserAction);
controller.addActionClass(DeleteUserAction);
controller.addActionClass(UserAction);
*/

controller.addActionClass(UserListAction, "list");
controller.addActionClass(EditUserAction, "edit");
controller.addActionClass(AddUserAction, "add");
controller.execute();
</script>

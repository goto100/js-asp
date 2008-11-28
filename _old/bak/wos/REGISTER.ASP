<!-- #include file = "common/common.asp" -->
<!-- #include file = "skins/default/templates/content.asp" -->
<!-- #include file = "source/register.asp" -->
<%
function outputViewAgreement() {
	thePage.outputStart();
%>
	<div id="rigister">
		<%thePage.outputH2(getLang("register") + " - Step 1")%>
		<div class="text">
			<%=getLang("register_agreement")%>
			<form method="post" action="register.asp">
				<input type="submit" name="acceptRigisterAgreement" value="<%=getLang("accept")%>" />
			</form>
		</div>
	</div>
<%
	thePage.outputEnd();
}

function outputFillForm() {
	thePage.outputStart();
%>
	<div id="register">
		<%thePage.outputH2(getLang("register") + " - Step 2")%>
		<form method="post" action="?act=submit">
			<fieldset>
				<legend><%=getLang("basic_profile")%></legend>
				<div class="formItem"><label for=""><%=getLang("username")%>:</label><input type="text" name="username" id="register_username" /></div>
				<div class="formItem"><label for=""><%=getLang("password")%>:</label><input type="password" name="password" /></div>
				<div class="formItem"><label for=""><%=getLang("confirm_password")%>:</label><input type="password" name="confirm_password" /></div>
			</fieldset>
			<fieldset>
				<legend><%=getLang("advanced_profile")%></legend>
				
			</fieldset>
			<input type="reset" value="<%=getLang("reset")%>" />
			<input type="submit" value="<%=getLang("submit")%>" />
		</form>
	</div>
<%
	thePage.outputEnd();
}
%>

<!-- #include file = "common/common.asp" -->
<!-- #include file = "source/setting.asp" -->
<%
function outputSetting(arrSetting, arrSkins, arrSkin) {
	thePage.outputStart(getLang("general_setting") + " - ");
%>
<div id="setting">
	<%thePage.outputH2(getLang("general_setting"))%>
		<form method="post" action="?act=submit">
			<fieldset>
				<legend><%=getLang("basic_setting")%></legend>
				<div class="formItem"><label><%=getLang("site_name")%>:</label><input name="siteName" type="text" class="text" value="<%=arrSetting.siteName%>" size="50" /></div>
				<div class="formItem"><label><%=getLang("site_description")%>:</label><input type="text" name="siteDescription" size="50" value="<%=arrSetting.siteDescription%>" class="text" /></div>
				<div class="formItem"><label><%=getLang("site_url")%>:</label><input type="text" name="siteURL" size="50" value="<%=arrSetting.siteURL%>" class="text" /></div>
				<div class="formItem"><label><%=getLang("site_path")%>:</label><input type="text" name="sitePath" size="50" value="<%=arrSetting.sitePath%>" class="text" /></div>
				<div class="formItem"><label><%=getLang("site_close_description")%>:</label><textarea name="siteCloseDesc" cols="30" rows="6"><%=arrSetting.siteCloseDesc%></textarea> <em class="tip">(<%=getLang("html_allowed")%>)</em></div>
				<div class="formItem"><label><%=getLang("site_webmaster")%>:</label><input type="text" name="siteWebmaster" size="50" value="<%=arrSetting.siteWebmaster%>" class="text" /></div>
				<div class="formItem"><label><%=getLang("webmaster_email")%>:</label><input type="text" name="siteWebMasterEmail" size="50" value="<%=arrSetting.siteWebMasterEmail%>" class="text" /></div>
				<div class="formItem"><label><%=getLang("smile_icon_folder")%>:</label><input type="text" name="smilesFolder" size="50" value="<%=arrSetting.smilesFolder%>" class="text" /></div>
			</fieldset>
			<fieldset>
				<legend><%=getLang("skin_setting")%></legend>
				<div class="formItem">
					<label><%=getLang("default_skin")%>:</label>
					<select name="defaultSkin"><%for (var i = 0; i < arrSkins.length; i++) {%>
						<option value="<%=arrSkins[i].codeName%>"<%if (theCache.setting.defaultSkin == arrSkins[i].codeName) {%> selected="selected"<%}%>><%=arrSkins[i].name%></option><%}%>
					</select>
				</div>
			  <div class="formItem">
					<label><%=getLang("default_lang")%>:</label>
					<select name="defaultLang"><%for (var i = 0; i < arrSkin.langs.length; i++) {%>
						<option value="<%=arrSkin.langs[i].name%>"<%if (theCache.setting.defaultLang == arrSkin.langs[i].name) {%> selected="selected"<%}%>><%=arrSkin.langs[i].name%></option><%}%>
					</select>
				</div>
			  <div class="formItem">
					<label><%=getLang("default_style")%>:</label>
					<select name="defaultStyle"><%for (var i = 0; i < arrSkin.styles.length; i++) {%>
						<option value="<%=arrSkin.styles[i].name%>"<%if (theCache.setting.defaultStyle == arrSkin.styles[i].name) {%> selected="selected"<%}%>><%=arrSkin.styles[i].name%></option><%}%>
					</select>
				</div>
			</fieldset>
				<div class="formItem"><input type="submit" value="<%=getLang("submit")%>" class="submit" /></div>
		</form>
</div>
<%
	thePage.outputSidebar();
	thePage.outputEnd();
}
%>
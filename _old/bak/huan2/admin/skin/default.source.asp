<%
function Main() {
	controller.checkPermission(system.user.getRight("administer"));

	var actList = controller.addAction(new ListAction);
	var actDefault = controller.addAction(new Action, "default");
	var actSetDefault = controller.addAction(new Action, "setdefault");
	var actSetDefaultStyle = controller.addAction(new Action, "setdefaultstyle");

	actList.action = function() {
		var skins = new HuanSkins;
		skins.skinsFolder = controller.rootPath + "_skins/";
		skins.load();
		outputer.outputSkins(skins, system.setting.defaultSkin);
	}

	actDefault.action = function() {
		var skin = new HuanSkin(system.setting.defaultSkin);
		skin.skinsFolder = controller.rootPath + "_skins/";
		if (!skin.load()) outputer.outputPage("badURL");
		else outputer.outputDefaultSkin(skin, system.setting.defaultStyle);
	}

	actSetDefault.action = function() {
		system.set({"defaultSkin": this.getIdParam("string")});
	}

	actSetDefaultStyle.action = function() {
		system.set({"defaultStyle": this.getIdParam("string")});
	}
}
%>
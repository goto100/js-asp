<!--#include file="../../common.asp" -->
<!--#include file="default.source.asp" -->
<%
function MainOutputer(controller) {
	this.outputSkins = function(skins, defaultId) {
		var page, i, eleSkin;

		page = controller.getPage(new ListPage("skins", skins));
		for (i = 0; i < skins.length; i++) {
			eleSkin = page.addItem({id: skins[i].id});
			if (skins[i].id == defaultId) eleSkin.addAttribute("isDefault", true);
			eleSkin.addChild("name", skins[i].name);
			eleSkin.addChild("version", skins[i].version);
			eleSkin.addChild("author", skins[i].author);
		}
		page.output();
	}

	this.outputDefaultSkin = function(skin, defaultStyleId) {
		var page, eleStyles, eleStyle;

		page = controller.getPage(new Page);
		page.setRoot("skin", null, {id: skin.id});
		page.content.addChild("name", skin.name);
		page.content.addChild("version", skin.version);
		page.content.addChild("author", skin.author);
		eleStyles = page.content.addChild("styles");
		for (i = 0; i < skin.styles.length; i++) {
			eleStyle = eleStyles.addChild("style", null, {id: skin.styles[i].id});
			if (skin.styles[i].id == defaultStyleId) eleStyle.addAttribute("isDefault", true);
			eleStyle.addChild("name", skin.styles[i].name);
			eleStyle.addChild("version", skin.styles[i].version);
			eleStyle.addChild("author", skin.styles[i].author);
		}		
		page.output();
	}
}
%>
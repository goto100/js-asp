<%
function Main() {
	controller.checkPermission(system.user.getRight("administer"));

	var actInfo = controller.addAction(new Action);
	var actReloadCache = controller.addAction(new Action, "reloadcache");
	var actBuildCache = controller.addAction(new Action, "buildcache");

	actInfo.action = function() {
		var info = {
			now: system.now,
			version: system.version,
			updateDate: system.updateDate,
			userCount: system.getUserCount(),
			memberCount: system.getMemberCount(),
			visitorCount: system.getVisitorCount()
		}
		outputer.outputInfo(info);
	}

	actReloadCache.action = function() {
		system.cache.reload();
		actInfo.execute("cacheReloaded");
	}

	actBuildCache.action = function() {
		system.cache.build(controller.rootPath + "_cache/huan/");
		actInfo.execute("cacheBuilt");
	}
}
%>
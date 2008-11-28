<script language="javascript" runat="server">
function HuanSetting(system) {
	this.siteName = "";
	this.siteURL = "";
	this.siteOpened = true;
	this.defaultLanguage = "";
	this.defaultSkin = "";
	this.defaultStyle = "";
	this.recordUsersTimeOut = true;
	this.recordVisitor = true;

	this.fill = function(record) {
		if (record.constructor == VBArray) {
			this.siteName = record.getItem(0, 0);
			this.siteURL = record.getItem(1, 0);
			this.siteOpened = record.getItem(2, 0);
			this.defaultLanguage = record.getItem(3, 0);
			this.defaultSkin = record.getItem(4, 0);
			this.defaultStyle = record.getItem(5, 0);
			this.recordUsersTimeOut = record.getItem(6, 0);
			this.recordVisitor = record.getItem(7, 0);
		} else {
			this.siteName = record.siteName;
			this.siteURL = record.siteURL;
			this.siteOpened = record.siteOpened;
			this.defaultLanguage = record.defaultLanguage;
			this.defaultSkin = record.defaultSkin;
			this.defaultStyle = record.defaultStyle;
			this.recordUsersTimeOut = record.recordUsersTimeOut;
			this.recordVisitor = record.recordVisitor;
		}
	}

	this.load = function() {
		var record = system.db.query("SELECT * FROM " + system.table.settings, 1);
		this.fill(record);
	}

	this.getVbArr = function() {
		return system.db.query("SELECT siteName, siteURL, siteOpened, defaultLanguage, defaultSkin, defaultStyle, recordUsersTimeOut, recordVisitor FROM " + system.table.settings, 1, null, true);
	}

	this.update = function(value) {
		if (value) this.fill(value);

		system.db.update(system.table.settings, {
			siteName: this.siteName,
			siteURL: this.siteURL,
			siteOpened: this.siteOpened,
			defaultLanguage: this.defaultLanguage,
			defaultSkin: this.defaultSkin,
			defaultStyle: this.defaultStyle,
			recordUsersTimeOut: this.recordUsersTimeOut,
			recordVisitor: this.recordVisitor
		});
	}

	this.set = function(setting) {
		system.db.update(system.table.setting, setting);
	}
}
</script>
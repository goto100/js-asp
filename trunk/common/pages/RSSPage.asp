<script language="javascript" runat="server">
function RSSPage(source, itemTitle, itemLink, itemDescription) {
	Page.apply(this, ["rss"]);

	this.content.addAttribute("version", "2.0");
	var eleChannel = this.content.addChild("channel");
	eleChannel.addChild("title", "a");
	eleChannel.addChild("link", "http://huan.local/huan/blog/");
	eleChannel.addChild("description", "c");
	for (var eleItem, i = 0; i < source.length; i++) {
		eleItem = eleChannel.addChild("item");
		eleItem.addChild("title", source[i][itemTitle]);
		eleItem.addChild("link", "?id=" + source[i][itemLink]);
		eleItem.addChild("description", source[i][itemDescription]);
	}
}
</script>
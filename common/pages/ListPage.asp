<script language="javascript" runat="server">
function ListPage(rootElement, source) {
	Page.apply(this, [rootElement]);

	this.content.addAttribute("page:type", "list");
	if (source) {
		this.content.addAttribute("pageSize", source.pageSize);
		this.content.addAttribute("pageCount", source.pageCount);
		this.content.addAttribute("currentPage", source.currentPage);
		this.content.addAttribute("recordCount", source.recordCount);
		this.content.addAttribute("keys", source.keys);
		if (source.orders) {
			var eleOrders = this.content.addChild("order");
			for (var i = 0; i < source.orders.length; i++) eleOrders.addChild(source.orders[i].order, null, {isDesc: source.orders[i].isDesc})
		}
	}

	this.addItem = function(attribute) {
		return this.content.addChild("item", null, attribute);
	}
}
</script>
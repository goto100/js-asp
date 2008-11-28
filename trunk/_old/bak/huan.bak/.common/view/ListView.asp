<script language="javascript" runat="server">
function ListView(rootElement, list)
{
	Page.call(this, rootElement);

	this.content.addAttribute("page:type", "list");
	if (list)
	{
		this.content.addAttribute("pageSize", list.pageSize);
		this.content.addAttribute("pageCount", list.pageCount);
		this.content.addAttribute("currentPage", list.currentPage);
		this.content.addAttribute("recordCount", list.recordCount);
		this.content.addAttribute("keys", list.keys);
		if (list.orders)
		{
			var eleOrders = this.content.addChild("order");
			for (var i = 0; i < list.orders.length; i++) eleOrders.addChild(list.orders[i].order, null, {isDesc: list.orders[i].isDesc})
		}
	}

	this.add = function(attribute)
	{
		return this.content.addChild("item", null, attribute);
	}
}
</script>
<script language="javascript" runat="server">
function FormView(rootName, form) {
	Page.call(this, rootName);

	this.setForm = function(item, node) {
		if (!node) node = this.content;
		for (var i in item) if (item.hasOwnProperty(i))
		{
			var eleForm = node.addChild(i);
			for (var j = 0; j < item[i].length; j++) {
				if (item[i][j].constructor == Object) this.setForm(item[i][j], eleForm);
				else {
					var ele = eleForm.addChild(item[i][j], form[item[i][j]]);
					if (form[item[i][j]] && form[item[i][j]].error) ele.addAttribute("error", form[item[i][j]].error.description);
				}
			}
		}
	}
}
</script>
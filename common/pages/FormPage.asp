<script language="javascript" runat="server">
function FormPage(rootName, form) {
	Page.apply(this, [rootName]);

	this.setForm = function(item, node) {
		if (!node) node = this.content;
		var e = item.getExpandoNames();
		for (var eleForm, i = 0; i < e.length; i++) {
			eleForm = node.addChild(e[i]);
			for (var j = 0; j < item[e[i]].length; j++) {
				if (item[e[i]][j].constructor == Object) this.setForm(item[e[i]][j], eleForm);
				else {
					var ele = eleForm.addChild(item[e[i]][j], form[item[e[i]][j]]);
					if (form[item[e[i]][j]] && form[item[e[i]][j]].error) ele.addAttribute("error", form[item[e[i]][j]].error.description);
				}
			}
		}
	}
}
</script>
<script language="javascript" runat="server">
function FormAction() {
	Action.call(this);

	this.value = null;

	this.getIdsParam = function() {
		if (this.search.ids) return this.toNumbers(this.search.ids, (/\,/ig), 0);
	}

	this.getValue = function(value) {
		var i;

		if (this.value) return this.value;
		if (value) return value;
		if (!arguments.length) return this.search;
		this.value = {};
		for (i = 0; i < arguments.length; i++) this.value[arguments[i]] = this.search[arguments[i]];
		return this.value;
	}
}
</script>
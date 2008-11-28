<script language="javascript" runat="server">
function UserRight(purview) {
	var lastCode = 0;
	var rightCode = {};

	this.purview = purview || 0;
	this.names = [];

	this.add = function(name) {
		rightCode[name] = lastCode++;
		this.names.push(name);
	}

	this.setPurview = function(right) {
		this.purview = 0;
		for (var i in right) if (right[i]) this.purview += Math.pow(2, rightCode[i]);
	}

	this.getRight = function() {
		var value = 0;
		for (var i = 0; i < arguments.length; i++) value += Math.pow(2, rightCode[arguments[i]]);
		return (this.purview & value) == value? true : false;
	}
}
</script>
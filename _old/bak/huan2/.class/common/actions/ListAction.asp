<script language="javascript" runat="server">
function ListAction() {
	Action.apply(this);

	// Custom list size
	this.getPageSize = function(normal) {
		if (this.search.pagesize) {
			try {
				return this.getNumber(this.search.pagesize, 1);
			} catch (e) {
				return normal;
			}
		}
		return normal;
	}

	// Page number
	this.getCurrentPage = function() {
		if (this.search.page) {
			try {
				return this.getNumber(this.search.page, 1);
			} catch (e) {
				return 1;
			}
		}
		return 1;
	}

	// List order
	this.getOrders = function(defaultOrder) {
		var i, orders, orderStr = this.search.orders? this.search.orders : defaultOrder;

		try {
			orders = this.getStrings(orderStr, /,\s*/ig);
		} catch (e) {
			return;
		}

		for (i = 0; i < orders.length; i++) {
			orders[i] = new String(orders[i]);
			orders[i].isDesc = false;

			if (orders[i].substr(orders[i].length - 1, 1) == "~") {
				orders[i].order = orders[i].substr(0, orders[i].indexOf("~"));
				orders[i].isDesc = true;
			} else orders[i].order = orders[i].valueOf();
		}

		if (orders.length) return orders;
	}

	this.getKeys = function() {
		if (!this.search.keys) return;

		try {
			var keys = this.getStrings(this.search.keys, /\s+/ig);
		} catch (e) {
			return;
		}

		if (keys.length) {
			var keyStr = this.search.keys;
			keys.toString = function() {
				return keyStr;
			}
			return keys;
		}
	}
}
</script>
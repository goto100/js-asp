<%
//////////////////////////////////////////////////
// Class Name: UserRight
// Author: ScYui
// Last Modify: 2005/9/25
//////////////////////////////////////////////////

function UserRight(conn) {
	////////// Attributes //////////////////////////////
	// Private //////////
	var rights = [];

	// Public //////////

	////////// Methods //////////////////////////////
	// Private //////////

	// Public //////////

	// Add right
	this.addRight = function(str, value) {
		rights.push({"name":str, "type":typeof(value), "value":value});
	}

	// Get rights
	this.getRights = function(groupId) {
		var tmpA = sys.conn.query("SELECT TOP 1 rights FROM [UserGroups] WHERE id = " + groupId);
		if (tmpA != null) {
			var rightsStr = tmpA["rights"];
			var rightValues = rightsStr.split(",");
			var returnRights = {};
			for (var i = 0; i < rights.length; i++) {
				switch (rights[i].type) {
					case "string":
						rights[i].value = rightValues[i].toString();
						break;
					case "boolean":
						rights[i].value = Boolean(parseInt(rightValues[i]));
						break;
					case "number":
						rights[i].value = parseInt(rightValues[i]);
						break;
				}
				returnRights[rights[i].name] = rights[i].value;
			}
			return returnRights;
		}
	}
}
%>

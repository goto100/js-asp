<%
function Manager() {
	this.dao = null;
}
Manager.prototype.setDao = function(dao) {
	this.dao = dao;
}
%>
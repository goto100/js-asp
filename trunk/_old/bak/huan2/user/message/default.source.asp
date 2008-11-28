<%
function Main() {
	var actList = controller.addAction(new ListAction);
	var actView = controller.addAction(new Action, "id");
	var actNew = controller.addAction(new FormAction, "new");
	var actSend = controller.addAction(new DBAction, "send");
	var actSent = controller.addAction(new ListAction, "sent");
	var actDelete = controller.addAction(new Action, "delete");

	actList.action = function() {
		var messages = system.user.getMessages();
		messages.setPage(this.getPageSize(20), this.getCurrentPage());
		messages.orders = this.getOrders("time~");
		messages.reciver = system.user;
		messages.load();
		outputer.outputList(messages);
	}

	actView.action = function() {
		var message = system.user.getMessage(this.getIdParam());
		if (!message.load()) controller.outputPage("badURL");
		else outputer.outputMessage(message);
	}

	actSent.action = function() {
		var messages = system.user.getMessages();
		messages.setPage(this.getPageSize(20), this.getCurrentPage());
		messages.orders = this.getOrders("time~");
		messages.sender = system.user;
		messages.sent = true;
		messages.load();
		outputer.outputSent(messages);
	}

	actNew.action = function() {
		outputer.outputNewForm(this.getValue());
	}

	actSend.action = function() {
		var i;

		this.withStringsParam("reciverUserIds", true);
		this.withStringParam("title", true);
		this.withStringParam("content", true);
		this.withBooleanParam("save");

		if (this.hasError) outputer.outputNewForm(this.form);
		else {
			var message = system.user.getMessage();
			for (i = 0; i < this.param.reciverUserIds.length; i++) {
				message.reciver = system.getUser();
				message.reciver.userId = this.param.reciverUserIds[i];
				message.reciver.loadId();
				message.send(this.param);
				if (this.param.save) message.save();
			}
			actList.execute("messageSent");
		}
	}

	actDelete.action = function() {
		var message = system.user.getMessage(this.getIdParam());
		if (!message.load()) controller.outputPage("badURL");
		else if (message.reciver.id == system.user.id || (message.sent && message.sender.id == system.user.id)) {
			message.del();
			message.sent? actSent.execute("messageDeleted") : actList.execute("messageDeleted");
		} else controller.outputPage("badURL"); // Block delete other's message
	}
}
%>
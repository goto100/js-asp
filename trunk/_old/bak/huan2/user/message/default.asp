<!--#include file="../../common.asp" -->
<!--#include file="default.source.asp" -->
<%
function MainOutputer(controller) {
	this.outputList = function(messages) {
		var i, page, eleMessage;

		page = controller.getPage(new ListPage("messages", messages));
		for (i = 0; i < messages.length; i++) {
			eleMessage = page.addItem({id: messages[i].id});
			eleMessage.addChild("sender", messages[i].sender.nickname, {id: messages[i].sender.id, read: messages[i].read});
			eleMessage.addChild("title", messages[i].title);
			eleMessage.addChild("sendTime", messages[i].sendTime);
		}

		page.output();
	}

	this.outputSent = function(messages) {
		var i, page, eleMessages;

		page = controller.getPage(new ListPage("sentMessages", messages));
		for (i = 0; i < messages.length; i++) {
			eleMessage = page.addItem({id: messages[i].id});
			eleMessage.addChild("reciver", messages[i].reciver.nickname, {id: messages[i].reciver.id, read: messages[i].read});
			eleMessage.addChild("title", messages[i].title);
			eleMessage.addChild("sendTime", messages[i].sendTime);
		}

		page.output();
	}

	this.outputNewForm = function(value) {
		var page;

		page = controller.getPage(new FormPage("new", value));
		page.content.addInfo("message").addForms("reciverUserIds", "title", "content");
		page.content.addInfo("send").addForms("save");
		page.output();
	}

	this.outputMessage = function(message) {
		var page;

		page = controller.getPage(new Page("message"));
		page.content.addAttribute("id", message.id);
		page.content.addChild("title", message.title);
		page.content.addChild("content", message.content);
		page.content.addChild("reciver", message.reciver.nickname, {id: message.reciver.id});
		page.content.addChild("sender", message.sender.nickname, {id: message.sender.id});
		page.content.addChild("sendTime", message.sendTime);

		page.output();
	}
}
%>
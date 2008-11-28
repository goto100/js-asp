function XMLHttp(strMethod, strURL, bAsync) {
	var request = create();

	this.func;

	this.responseXML = {};
	this.responseText = {};

	request.open(strMethod, strURL, bAsync);

	this.send = function(content) {
		if (content == undefined) {
			if (window.XMLHttpRequest) {
				request.send(null);
			} else if (window.ActiveXObject) {
				request.send();
			}
		} else {
			request.send(content);
		}

		if (bAsync == false) { // Wait file load
			this.responseXML = request.responseXML;
			this.responseText = request.responseText;

			this.func();
		} else {
			request.onreadystatechange = function() {
				if (request.readyState == 4) {
					if (request.status == 200) {
						this.responseXML = request.responseXML;
						this.responseText = request.responseText;

						this.func();
					}
				}
			}
		}
	}

	function create() {
		if (window.XMLHttpRequest) { // Mozilla
			try {
				return new XMLHttpRequest();
			} catch(e) {
				outputErrorMsg(e);
			}
		} else if (window.ActiveXObject) { // IE
			try {
				return new ActiveXObject("Microsoft.XMLHttp");
			} catch(e) {
				outputErrorMsg(e);
			}
		} else {
			outputErrorMsg("Create XMLHttpRequest object error.")
		}
	}

}

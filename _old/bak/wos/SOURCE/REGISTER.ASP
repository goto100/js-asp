<%
switch(query["act"]) {
	case "submit":
		break;

	default:
		if (input["acceptRigisterAgreement"]) {
			setSession("RegisterStep", 2);
			outputFillForm();
		} else {
			if (getSession("RegisterStep") == 2) {
				removeSession("RegisterStep");
				var ei = checkEmptyInputs("username", "password");
				if (ei) {
					thePage.outputAlert("faf");
				}
			} else {
				setSession("RegisterStep", 1);
				outputViewAgreement();
			}
		}
}
%>
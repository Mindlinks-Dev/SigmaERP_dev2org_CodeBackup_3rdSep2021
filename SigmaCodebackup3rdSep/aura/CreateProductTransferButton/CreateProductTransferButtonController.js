({
	checkProductRequestStatus : function(component, event, helper) {
		helper.checkProductRequestStatusHelper(component,event);
	},
    createProductTransfer : function(component, event, helper) {
		helper.createProductTransferHelper(component,event);
	},
    closeWindow : function(component, event, helper) {
		$A.get("e.force:closeQuickAction").fire();
	}
})
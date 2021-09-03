({
	approveProductRequest : function(component, event, helper) {
		helper.approveProductRequestHelper(component,event);
	},
    closeWindow : function(component, event, helper) {
		$A.get("e.force:closeQuickAction").fire();
	}
})
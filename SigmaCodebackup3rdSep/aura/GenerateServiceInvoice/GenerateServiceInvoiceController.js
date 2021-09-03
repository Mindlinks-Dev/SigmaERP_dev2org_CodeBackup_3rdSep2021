({
	doInit : function(component, event, helper) {
        console.log('test');
        helper.generatePDF(component,event,helper);
        console.log('after gen pdf....');
        helper.updateWorkOrderStatus(component,event,helper);
    },
    closeWindow : function(component, event, helper) {
		$A.get("e.force:closeQuickAction").fire();
	}
})
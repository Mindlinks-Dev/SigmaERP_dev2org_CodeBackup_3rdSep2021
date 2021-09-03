({
    
    //This function will handle 'Previous' button Action.
	previousPage : function(component, event, helper) {
        var myEvent = component.getEvent("CommPageChange");
        myEvent.setParams({ "direction": "previous"});
        myEvent.fire();
	},
    //This function will handle 'Next' button Action.
	nextPage : function(component, event, helper) {
        var myEvent = component.getEvent("CommPageChange");
        myEvent.setParams({ "direction": "next"});
        myEvent.fire();
	}
})
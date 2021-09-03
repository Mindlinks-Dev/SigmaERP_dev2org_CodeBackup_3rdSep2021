({
	fetchBPCustomers : function(component, event, helper) {
		var action = component.get("c.getBPCustomers");
        action.setCallback(this, function(response) {
            if(response.getState() == "SUCCESS"){                
                var allValues = response.getReturnValue();
                component.set("v.bpsList", allValues);
            }
            var spinner = component.find("mySpinner");
            $A.util.toggleClass(spinner, "slds-hide");
        });
        $A.enqueueAction(action);
	}
})
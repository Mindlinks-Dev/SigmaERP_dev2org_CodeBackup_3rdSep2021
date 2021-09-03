({
	changeStatusH : function(component, event, helper) {
        var brewId = component.get("v.rowDetails.sigmaerpdev2__Brewer_Account__c");
        
        var selectedMenuItemValue = component.get("v.rowDetails.sigmaerpdev2__Registration_Status__c");        
		var action = component.get("c.changeBPStatus");
        action.setParams({ 
            "brewID" : brewId,                          
            "status" : selectedMenuItemValue
        });
        action.setCallback(this, function(response) {
            
            if(response.getState() == "SUCCESS"){  
                var retVal = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success!",
                    "message": "Brewery Producer status updated successfully!"
                });
                toastEvent.fire();
                component.set("v.rowDetails.sigmaerpdev2__Registration_Status__c", retVal);
            }
            var spinner = component.find("mySpinner");
            $A.util.toggleClass(spinner, "slds-hide");
        });
        $A.enqueueAction(action);
	}
})
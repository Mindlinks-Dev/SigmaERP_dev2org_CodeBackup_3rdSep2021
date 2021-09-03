({
	fetchBPs : function(component, event, helper) {
		var action = component.get("c.getBPsList");
        action.setCallback(this, function(response) {
            if(response.getState() == "SUCCESS"){                
                var allValues = response.getReturnValue();
                /*for(var i=0;i<allValues.length;i++){
                    allValues[i].CreatedDate = allValues[i].CreatedDate.substring(0,10);
                }*/
                component.set("v.bpsList", allValues);
            }
            var spinner = component.find("mySpinner");
            $A.util.toggleClass(spinner, "slds-hide");
        });
        $A.enqueueAction(action);
	}
    
    /*fetchBPs : function(component, event, helper) {
		var action = component.get("c.getBPsList");
        action.setCallback(this, function(response) {
            if(response.getState() == "SUCCESS"){                
                var allValues = response.getReturnValue()[0].mainWrapBPList;
                //alert('res==='+JSON.stringify(allValues));
                
                component.set("v.bpsList", allValues);
            }
            var spinner = component.find("mySpinner");
            $A.util.toggleClass(spinner, "slds-hide");
        });
        $A.enqueueAction(action);
	}*/
})
({
	helperMethod : function(component, event, helper) {

		 var action = component.get("c.fetchJSONHelpMenu");
        //alert(cmp.get("v.recordId"));
        //action.setParams({ recId : cmp.get("v.recordId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var jsonData=response.getReturnValue();
               	component.set('v.jsonString',jsonData[0]);      
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
	}
})
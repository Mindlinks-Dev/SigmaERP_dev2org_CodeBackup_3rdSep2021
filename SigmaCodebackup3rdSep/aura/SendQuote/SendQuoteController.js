({
        apexExecute : function(component, event, helper) {
            //Call Your Apex Controller Method.
            var action = component.get("c.send");
            action.setParams({
                'acctid': ''+component.get('v.recordId')+''
            });

            action.setCallback(this, function(response) {
                var state = response.getState();
               // alert(state);
                    if (state === "SUCCESS") {
                        //after code
                        response.getReturnValue();
					 component.set("v.showSuccess", true);
                        $A.get("e.force:closeQuickAction").fire();
                    } 
            });
            
            $A.enqueueAction(action);
	},
     closeWindow : function(component, event, helper) {
		$A.get("e.force:closeQuickAction").fire();
	}
})
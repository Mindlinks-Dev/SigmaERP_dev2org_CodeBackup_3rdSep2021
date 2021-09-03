({
	doInit : function(component, event, helper) {
        var action = component.get("c.SelectOrders");
  		action.setCallback(this, function(response) {
            var state = response.getState();
            // alert(state);
            if (state === "SUCCESS") 
            {
                // alert(response.getReturnValue());
                component.set('v.isSigmaOrder',response.getReturnValue()); 
                
            }
        });
        $A.enqueueAction(action);    
	}
})
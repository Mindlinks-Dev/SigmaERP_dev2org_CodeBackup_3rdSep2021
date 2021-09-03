({
    
	cancelwo : function(component,event,helper) {
        var recId = component.get("v.recordId");
         alert('rec>>'+recId);
        if(recId!=null && recId !=''){ 
            var action = component.get("c.cancelWO");
        action.setParams({ recId : recId});
            action.setCallback(this, function(response) {
            var state = response.getState();
            alert(state);
            if (state =="SUCCESS") 
            {
                alert('enter state');
              component.set("v.showSuccess", true);

                
            }
        });
        $A.enqueueAction(action);
        }
		
	}
})
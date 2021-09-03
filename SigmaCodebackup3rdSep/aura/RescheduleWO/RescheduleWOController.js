({
	myAction : function (cmp, event, helper) {
        alert('rec>>'+recordId);
        var recId = component.get("v.recordId");
        if(recId!=null && recId !=''){ 
            var action = component.get("c.rescheduleWO");
        action.setParams({ recId : recId});
            action.setCallback(this, function(response) {
            var state = response.getState();
             alert(state);
            if (state =="SUCCESS") 
            {                
            }
        });
        $A.enqueueAction(action);
        }
    }
})
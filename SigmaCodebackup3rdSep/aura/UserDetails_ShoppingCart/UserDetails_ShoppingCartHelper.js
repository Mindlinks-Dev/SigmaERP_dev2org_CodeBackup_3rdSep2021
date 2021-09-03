({
    handleSubmit : function(component, event, helper) {
        var action = component.get("c.createAccount");
        action.setParams({
            ac : component.get('v.createAcc')
        });
        action.setCallback(this,function(result){
            var getAllValue = component.get('v.createAcc');
            // alert(JSON.stringify(getAllValue));
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Thank you for entering details.",
                "type": "success",
                "message": "Soon our representative will contact you.",
                "mode": "sticky"
            });            
            toastEvent.fire();
            setTimeout(function(){ 
                location.reload(); 
            }, 3000);
        });
        $A.enqueueAction(action);
    }
})
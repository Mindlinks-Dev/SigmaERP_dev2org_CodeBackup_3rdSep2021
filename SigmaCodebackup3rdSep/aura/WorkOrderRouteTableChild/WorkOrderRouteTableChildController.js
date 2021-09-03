({
    navigate : function(component, event, helper) {
        //Navigate the link to the corersponding record ID.
        var navEvt = $A.get("e.force:navigateToSObject");
        // alert(component.get("v.caserecordID"));
        navEvt.setParams({
            "recordId": component.get("v.eachWorkOrder.workOrderId")
        });
        navEvt.fire();
        //alert('innns'+component.get("v.eachWorkOrder.workOrderId"));
    },
    
    initalise : function(component, event, helper) {
        var contactNumber = component.get('v.eachWorkOrder.contactNumber');
        //if the contact number is null make it as Not Available.
        if(contactNumber == null){
            component.set('v.eachWorkOrder.contactNumber','NA');
        }
    }
})
({
	doInit : function(component, event,helper) {
       // alert(component.get("v.recordId"));
        component.set("v.sigmaOrderIdForClone",component.get("v.recordId"));
       //alert('sigmaOrderIdForClone 11'+component.get("v.sigmaOrderIdForClone"));
        //helper.setPayment(component,event,helper);
        var editRecordEvent = $A.get("e.force:navigateToComponent");
        editRecordEvent.setParams({
            componentDef: "c:SigmaOrder",
            componentAttributes: {
                sigmaOrderIdForClone: component.get("v.sigmaOrderIdForClone"),
            }
        });
        editRecordEvent.fire();
    },
})
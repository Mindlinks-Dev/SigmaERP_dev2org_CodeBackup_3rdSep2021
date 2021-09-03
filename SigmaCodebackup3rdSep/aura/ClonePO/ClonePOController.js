({
    doInit : function(component, event, helper) {
        component.set("v.POIdForClone",component.get("v.recordId"));
        //alert(component.get("v.POIdForClone"));
        var editRecordEvent = $A.get("e.force:navigateToComponent");
        editRecordEvent.setParams({
            componentDef: "c:NewPurchaseOrder",
            componentAttributes: {
                POIdForClone: component.get("v.POIdForClone"),
                
            }
        });
        editRecordEvent.fire();    
    },
})
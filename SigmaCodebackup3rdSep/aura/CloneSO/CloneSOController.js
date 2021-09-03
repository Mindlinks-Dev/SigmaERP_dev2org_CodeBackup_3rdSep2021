({
	doInit : function(component, event, helper) {
		component.set("v.SOIdForClone",component.get("v.recordId"));
        //alert(component.get("v.POIdForClone"));
        var editRecordEvent = $A.get("e.force:navigateToComponent");
        editRecordEvent.setParams({
            componentDef: "c:SigmaOrder",
            componentAttributes: {
                SOIdForClone: component.get("v.SOIdForClone"),
                
            }
        });
        editRecordEvent.fire(); 
	}
})
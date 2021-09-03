({
    editRecord : function(component, event, helper) {
        var recId = component.get('v.ILP.Id');
        var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
            "recordId": recId
        });
        editRecordEvent.fire();
    }
})
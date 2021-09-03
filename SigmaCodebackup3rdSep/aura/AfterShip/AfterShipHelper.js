({
    getShipment: function(cmp) {
        $A.get("e.force:refreshView").fire();
        var action = cmp.get("c.getShipdetails");
        action.setParams({shipId:cmp.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.shipment",response.getReturnValue());
            }
            else if (state === "ERROR") {
                var errors = response.getError();
            }
        });
        $A.enqueueAction(action);
    }
})
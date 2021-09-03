({
    toGetRetailerData: function(component, event,helper) {
        var action = component.get('c.retailerCodeDisplay');
        var self = this;
        action.setCallback(this, function(actionResult) {
            var status=actionResult.getState();
            if(status=="SUCCESS")
            {
            component.set('v.RoList', actionResult.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    loadCatalogOrder: function(component, event,helper) 
    {
        component.set("v.Retailercmp",false);
        component.set("v.Catalogcmp",true);
    }
})
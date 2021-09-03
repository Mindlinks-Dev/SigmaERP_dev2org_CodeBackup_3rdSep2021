({
    helperMethod : function() {
        
    },
    removeProductItem : function(component, index) {
        var ShipmentProductsList = component.get("v.ShipmentProducts");
        var action = component.get("c.deleteShipmentProd");
        action.setParams({
            "ShipmentProducts":JSON.stringify(ShipmentProductsList),
            "idx":index
        });
        
        ShipmentProductsList.splice(index, 1);
        component.set("v.ShipmentProducts", ShipmentProductsList);
        $A.enqueueAction(action);
        
    },
    
    upsertShipment : function(component) {
        var newShipment=component.get('v.Shipment');
        var action = component.get('c.CreateProductMethod');
        action.setParams
        ({ 
            "ProductObj" : newShipment
        });
        action.setCallback( this, function(a) {
            var state = a.getState();
            alert('state'+a.getReturnValue());
            if (state === "SUCCESS") 
            {
                var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type":"success",
                            "title": "Success!",
                            "message": "Product record created successfully!"
                        });
                        toastEvent.fire();   
            }
            else
            {
                var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type":"error",
                            "title": "error!",
                            "message":"  Product record is not created successfully!"
                        });
                        toastEvent.fire(); 
            }
        });
        $A.enqueueAction(action);
    }
})
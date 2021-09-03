({
	 removeProductItem : function(component, index) {
        var ShipmentProductsList = component.get("v.ShipmentProduct");
        var i=index;
        
        var action = component.get("c.deleteShipmentProd");
        action.setParams({
            "ShipmentProducts":JSON.stringify(ShipmentProductsList),
            "idx":index
        });
        ShipmentProductsList.splice(index, 1);
        component.set("v.ShipmentProduct", ShipmentProductsList);
       
    }
 
      
})
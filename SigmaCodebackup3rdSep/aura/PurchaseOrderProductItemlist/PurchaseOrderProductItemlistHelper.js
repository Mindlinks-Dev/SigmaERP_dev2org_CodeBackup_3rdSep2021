({
    removeProductItem : function(component, index) {
        var purchaseOrderList = component.get("v.purchaseOrder");
        
        var i=index;
        
        
        purchaseOrderList.splice(index, 1);
        
        component.set("v.purchaseOrder", purchaseOrderList);
        
        
    }
    
})
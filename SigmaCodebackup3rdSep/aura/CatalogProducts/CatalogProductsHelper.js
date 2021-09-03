({
   
    saveToCart: function(component, event,helper,index) 
    {
        var custid = component.get("v.onselectcustomeid");
        var indexarr = index.split(" ");
        var completeData = component.get("v.SigProductList")[indexarr];
        var qty = completeData.quantity;
        if(!qty || qty<=0)
        {         
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Warning",
                message: 'Entered Product Quantity is not valid',
                type: "warning"
            });
            toastEvent.fire();
            return;
        }
        var actionsave = component.get("c.saveSO");
        actionsave.setParams({ 
            ProductId : completeData.Id,
            ProductPrice : completeData.ProductPrice,
            Avlquantity : completeData.AvailableQuantity,
            EnteredQuantity : completeData.quantity
        });
        actionsave.setCallback(this, function(response) 
                               {
                                   var state = response.getState();
                                   console.log('state:::'+state);
                                   if (state === "SUCCESS") 
                                   {
                                       var toastEvent = $A.get("e.force:showToast");
                                       toastEvent.setParams({
                                           title: "success",
                                           message: 'Product added to cart successfully',
                                           type: "success"
                                       });
                                       toastEvent.fire();
                                   }
                                   else if (state === "INCOMPLETE") {
                                       // do something
                                   }
                                       else if (state === "ERROR") 
                                       {
                                           var toastEvent = $A.get("e.force:showToast");
                                           toastEvent.setParams({
                                               title: "Error",
                                               message: 'Add to cart Failed',
                                               type: "Error"
                                           });
                                           toastEvent.fire();
                                           var errors = response.getError();
                                           if (errors) {
                                               if (errors[0] && errors[0].message) {
                                                   console.log("Error message: " + 
                                                               errors[0].message);
                                               }
                                           } 
                                           else {
                                               console.log("Unknown error");
                                           }
                                       }
                               });
        $A.enqueueAction(actionsave);  
        component.set("qty",'');
    }
})
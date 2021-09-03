({
	validateQuantity : function(component, event, helper) {
           var qty = component.get("v.details.selQuantity");
        var qty1= component.get("v.details.ilpAvailQuantity");
        
         if(qty !== null)
            {
                 if(qty < 0)
                {
                    var msg = "Quantity should Positive";
                    component.set("v.errorMsg", msg);
                    component.set("v.isError",true);
                    return;
                    
                }
                
                if(qty1<qty)
                {
                     var msg = "Quantity should Positive ";
                    component.set("v.errorMsg", msg);
                    component.set("v.isError",true);
                    return;
                    
                    
                }
                

            }

		
	}
})
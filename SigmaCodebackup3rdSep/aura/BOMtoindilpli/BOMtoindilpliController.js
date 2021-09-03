({
	
	  validateQuantity : function(component, event, helper)
    {
		var availQuantity = component.get("v.IlpliItem.eachLineItemILPLI.sigmaerpdev2__Available_Quantity__c");
        var selQuantity = component.get("v.IlpliItem.pickQty");
        //alert('selQuantity>>'+JSON.stringify(selQuantity));
         if(selQuantity == undefined || selQuantity == null || selQuantity =="")
            {
             //   alert('in');
                component.set("v.IlpliItem.pickQty",0);
            }
        if(selQuantity > availQuantity){
           component.find("quantity").set("v.errors", [{message:"Pick Quantity should be less than or equal to available quantity."}]);
          // component.set("v.istrue",false);
           return;
        } 
       else if( (selQuantity %1)!=0) {
            component.find("quantity").set("v.errors", [{message:"Pick quantity should not be negative or less than Zero"}]);
         //   component.set("v.istrue",true);
            return;
        }
       else if( selQuantity < availQuantity || selQuantity == availQuantity) {
            component.find("quantity").set("v.errors", [{message:""}]);
           // component.set("v.istrue",true);
            return;
            
        }
       
       
	}
})
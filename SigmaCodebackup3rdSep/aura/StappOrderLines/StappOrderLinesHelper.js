({
	getProductDataEdit: function (component, event, helper, prodId) {
        var action = component.get("c.getProdRelData");
        action.setParams({
            "prodId": prodId,
        });
	action.setCallback(this, function (a) {
            var state = a.getState();
               //alert('state::'+state);
            if (state == "SUCCESS") {
                if(a.getReturnValue()!=null)
                {
                    //alert( "before::"+component.get("v.standOrder.sigmaerpdev__ShippingPostalCode__c"));
                    var product=a.getReturnValue();	
                    
                  //  alert(JSON.stringify(product));
                     component.set("v.availableQuantity",product.sigmaerpdev__Product_Inventory__r[0].sigmaerpdev__Available_Qty__c);
                     component.set("v.StandardOrderLines.sigmaerpdev__Total_Amount__c",product.sigmaerpdev__Product_Price__c);
                     component.set("v.maxdiscount",product.sigmaerpdev__Max_Discount__c);
                    //alert('maxdiscount::'+ component.get("v.maxdiscount"));
                    
                    // alert( "price"+component.get("v.StandardOrderLines.sigmaerpdev__Total_Amount__c"));
                  //  alert( "total Available"+JSON.stringify(component.get("v.StandardOrderLines.sigmaerpdev__Remaining_Qty_To_Package__c")));
                
                }
            }
         });
          $A.enqueueAction(action);
    },
    handleBackOrder: function(component, event, helper,source)
    {
        var StandOrderCmpEvent = component.getEvent("StandOrderCmpEvent");
        StandOrderCmpEvent.setParams({
            "data" : {"index":component.get('v.indexNum'),"avail":component.get("v.availableQuantity"),"source":source},
            "flag" : "backOrderLines"
        });
        StandOrderCmpEvent.fire();
    }
})
({
	validateQuantity : function(component, event, helper) {
        var availQuantity = component.get("v.lineItem.eachLineItemILPLI.sigmaerpdev2__Available_Quantity__c");
        var qty=component.get("v.lineItem.pickQty");
       // alert('qty>>'+JSON.stringify(qty));
        if(qty == undefined || qty == null || qty =="")
            {
               // alert('in');
                component.set('v.lineItem.pickQty',0);
            }
        if(qty > availQuantity){
            component.find("quantity").set("v.errors", [{message:"Pick Quantity should be less than or equal to available quantity."}]);
           //component.set("v.istrue",false);
            return;
        } 
        else if( (qty % 1)!=0) {
            component.find("quantity").set("v.errors", [{message:"Pick quantity should not be negative or Less than Zero"}]);
         //  component.set("v.istrue",true)
             return;
        }
        else if( qty <  availQuantity || qty == availQuantity  ) {
            component.find("quantity").set("v.errors", [{message:""}]);
         //   component.set("v.istrue",true)
            return;
            
        }	
	},
     selectMalually: function (component, event, helper) {
        
        var availQuantity = component.get("v.lineItem.eachLineItemILPLI.sigmaerpdev2__Available_Quantity__c");
        var qty=component.get("v.lineItem.pickQty");
       // alert('qty>>'+JSON.stringify(qty));
        if(qty == undefined || qty == null || qty =="")
            {
               // alert('in');
                component.set('v.lineItem.pickQty',0);
            }
        if(qty > availQuantity){
            component.find("quantity").set("v.errors", [{message:"Pick Quantity should be less than or equal to available quantity."}]);
           //component.set("v.istrue",false);
            return;
        } 
        else if( (qty % 1)!=0) {
            component.find("quantity").set("v.errors", [{message:"Pick quantity should not be negative or Less than Zero"}]);
         //  component.set("v.istrue",true)
             return;
        }
        else if( qty <  availQuantity || qty == availQuantity  ) {
            component.find("quantity").set("v.errors", [{message:""}]);
         //   component.set("v.istrue",true)
            return;
            
        }	
        var SigmaComponentEvent = component.getEvent("SigmaComponentEvent");
        SigmaComponentEvent.setParams({
            "data" : {"index":component.get('v.indexNum')},
            "flag" : "manualSelectILPLI"
        });
        SigmaComponentEvent.fire();
    },
    autoPickInventory: function (component, event, helper) {
        var availQuantity = component.get("v.lineItem.eachLineItemILPLI.sigmaerpdev2__Available_Quantity__c");
        var qty=component.get("v.lineItem.pickQty");
       // alert('qty>>'+JSON.stringify(qty));
        if(qty == undefined || qty == null || qty =="")
            {
               // alert('in');
                component.set('v.lineItem.pickQty',0);
            }
        if(qty > availQuantity){
            component.find("quantity").set("v.errors", [{message:"Pick Quantity should be less than or equal to available quantity."}]);
           //component.set("v.istrue",false);
            return;
        } 
        else if( (qty % 1)!=0) {
            component.find("quantity").set("v.errors", [{message:"Pick quantity should not be negative or Less than Zero"}]);
         //  component.set("v.istrue",true)
             return;
        }
        else if( qty <  availQuantity || qty == availQuantity  ) {
            component.find("quantity").set("v.errors", [{message:""}]);
         //   component.set("v.istrue",true)
            return;
            
        }	
        var SigmaComponentEvent = component.getEvent("SigmaComponentEvent");
        SigmaComponentEvent.setParams({
            "data" : {"index":component.get('v.indexNum')},
            "flag" : "autoPickILPLI"
        });
        SigmaComponentEvent.fire();
    },
})
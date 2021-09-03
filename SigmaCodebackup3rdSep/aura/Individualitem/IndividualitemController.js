({
	validateQuantity : function(component, event, helper) {
     //  alert('came');
        var availQuantity = component.get("v.lineItem.eachLineItemILPLI.sigmaerpdev2__Available_Quantity__c");
        var producttransfer = component.get("v.lineItem.eachLineItemILPLIWrapper");
         for(var i=0; i<producttransfer.length; i++)
        {
            var reqant = producttransfer[i].pickQty;
            var data1 =  producttransfer[i].eachLineItemILPLI.sigmaerpdev2__Available_Quantity__c;
           // alert('data1>>'+JSON.stringify(data1));
            if(reqant < 0)
            {
                alert('0');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message:'Pick quantity should not be negative or Less than Zero',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
                return; 
               /* 
                component.find("quantity").set("v.errors", [{message:"Pick quantity should not be negative or Less than Zero"}]);
                component.set("v.isError",true);
                return;*/
            }
            else if(reqant > data1 )
            {
                alert('1');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message:'Pick Quantity should be less than or equal to available quantity',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
                return; 
               /* component.find("quantity").set("v.errors", [{message:"Pick Quantity should be less than or equal to available quantity."}]);
                return;*/ 
            }
        }
 
        var qty=component.get("v.lineItem.pickQty");
       // alert('qty validate>>'+component.get("v.lineItem.pickQty"));
       //  alert('isError>>'+component.get("v.isError"));
        if(qty == undefined || qty == null || qty =="")
            {
               // alert('in');
                component.set('v.lineItem.pickQty',0);
            }
        if(qty > availQuantity){
           alert('came in'+availQuantity);
            component.find("quantity").set("v.errors", [{message:"Pick Quantity should be less than or equal to available quantity."}]);
           //component.set("v.istrue",false);
            return;
        } 
        else if( (qty % 1)!=0) {
           //alert('(qty % 1)>>>>'+(qty % 1)!=0);
            component.find("quantity").set("v.errors", [{message:"Pick quantity should not be negative or Less than Zero"}]);
         //  component.set("v.istrue",true)
            component.set("v.isError",true);
             return;
        }
        else if( qty <  availQuantity || qty == availQuantity  ) {
           // alert('in123>>>>'+qty);
            component.find("quantity").set("v.errors", [{message:""}]);
         //   component.set("v.istrue",true)
            return;
            
        }	
	},
     selectMalually: function (component, event, helper) {
        
        var availQuantity = component.get("v.lineItem.eachLineItemILPLI.sigmaerpdev2__Available_Quantity__c");
        var qty=component.get("v.lineItem.pickQty");
      // alert('qty manualy>>'+JSON.stringify(qty)+'isError>>>'+isError );
         //  alert('isError>>'+isError);
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
            // alert('(qty % 1)>>>'+(qty % 1)!=0 );
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
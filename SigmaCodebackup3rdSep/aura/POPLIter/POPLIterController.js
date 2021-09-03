({
     doInit : function(component, event, helper) 
    {
        var action3 = component.get("c.getPOProductStatus");
        action3.setCallback(this, function(a3)
                            {
                                component.set("v.vpline.pop.sigmaerpdev2__Product__c",component.get("v.vpline.pop.sigmaerpdev2__Product__c")); 
                                component.find("Product").set("v.searchString",component.get("v.vpline.pop.sigmaerpdev2__Product__r.Name"));
                                component.set("v.status", a3.getReturnValue());
                                component.find("statuss").set("v.value", component.get("v.vpline.pop.sigmaerpdev2__Status__c")); 
                                component.set("v.vpline.pop.sigmaerpdev2__Status__c",component.find("statuss").get("v.value"));
                                component.set("v.vpline.pop",component.get("v.vpline.pop"));
                            });        
        $A.enqueueAction(action3);
    },
    getvendorid:function(component, event, helper) {
        alert('hi')
        var vendorid=component.get("v.Pur_Order.sigmaerpdev2__Product_Supplier__c");
        alert('vendorid>>>>>'+vendorid)
        component.set("v.vendorid",vendorid);
        
         },
    
    
	changeHandler:function(component, event, helper) {
       // alert('hi')
        if(component.get("v.vpline.pop.sigmaerpdev2__Quantity__c") - Math.floor(component.get("v.vpline.pop.sigmaerpdev2__Quantity__c")) !== 0)
        {
            alert('Decimals not allowed in Quantity');
            component.set("v.vpline.pop.sigmaerpdev2__Quantity__c",parseInt(component.get("v.vpline.pop.sigmaerpdev2__Quantity__c")));
        }
        if(component.get("v.vpline.pop.sigmaerpdev2__Quantity__c")<0)
        {
            alert('Negative values not allowed in Quantity');
            component.set("v.vpline.pop.sigmaerpdev2__Quantity__c",component.get("v.vpline.pop.sigmaerpdev2__Quantity__c")*-1);
        }
        helper.netTotalAmountCalculator(component, event, helper);
    },
    getProddata:function(component, event, helper) {
        if (component.get("v.vpline") && !component.get("v.vpline.pop.sigmaerpdev2__Product__c"))
            helper.remProddata(component, event, helper);
         
    },
     handleLookupValueselected: function (component, event, helper) {
        if(event.getParam("objectAPIName")==='Product2'){
            helper.getProductRelatedData(component, event, helper,'LookUpChange');
           helper.getProductRelatedDatabp(component, event, helper,'LookUpChange');
           
        }
       
            else if(event.getParam("objectAPIName")==='sigmaerpdev2__Tax_Code__c'){
                
                var SigmaComponentEvent = component.getEvent("SigmaComponentEvent");
                SigmaComponentEvent.setParams({
                    "flag": "TaxFlag"
                });
                SigmaComponentEvent.fire();
               // alert( 'after fire')
            }
     },
    handleComponentEvent:function(component, event, helper) {
          // alert('1>>>>'+event.getParam("flag"))
        if (event.getParam("flag") == 'clearLookup')
        {
            if(event.getParam("data").objectAPIName == 'Product2')
            {
                var SigmaComponentEvent = component.getEvent("SigmaComponentEvent");
                SigmaComponentEvent.setParams({
                    "flag": "TaxFlag"
                });
                SigmaComponentEvent.fire();
            }
            else if(event.getParam("data").objectAPIName == 'sigmaerpdev2__Tax_Code__c')
            {
                var SigmaComponentEvent = component.getEvent("SigmaComponentEvent");
                SigmaComponentEvent.setParams({
                    "flag": "TaxFlag"
                });
                SigmaComponentEvent.fire();
            }
           
        }
    },
      discountChangeHandler:function(component, event, helper) {
        
          
          /*  if(component.get('v.vpline.pop.sigmaerpdev2__Discount__c')*1>component.get('v.vpline.pop.sigmaerpdev2__Net_Amount__c')*1)
            {
                alert('Discount should not be greater than Net Amount');
                component.set('v.vpline.pop.sigmaerpdev2__Discount__c',0);
            }
             if(component.get('v.vpline.pop.sigmaerpdev2__Discount__c')*1<0)
            {
                alert('Negative values not allowed in Discount');
                component.set('v.vpline.pop.sigmaerpdev2__Discount__c',component.get('v.vpline.pop.sigmaerpdev2__Discount__c')*-1);
            }*/
           if(component.get('v.vpline.pop.sigmaerpdev2__Discount__c')>100)
            {
                alert('Discount Percentage should not be greated than 100%');
                component.set('v.vpline.pop.sigmaerpdev2__Discount__c',100);
            }
            else if(component.get('v.vpline.pop.sigmaerpdev2__Discount__c')<0)
            {
                alert('Negative values not allowed in Discount');
                component.set('v.vpline.pop.sigmaerpdev2__Discount__c',component.get('v.vpline.pop.sigmaerpdev2__Discount__c')*-1);
            }
        
        helper.netTotalAmountCalculator(component, event, helper);
    },
    removeRow: function(component, event, helper) {
      component.getEvent("DeleteRowEvt").setParams({"indexVar" : component.get("v.rowIndex")}).fire();
    },
})
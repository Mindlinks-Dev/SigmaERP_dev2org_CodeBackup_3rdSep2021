({
    doInit: function (component, event, helper) {
        // alert('date'+JSON.stringify(component.get("v.StandardOrderLines")));
        if(!component.get("v.StandardOrderLines.sigmaerpdev__Delivary_Date__c")){
            component.set("v.StandardOrderLines.sigmaerpdev__Delivary_Date__c", $A.localizationService.formatDate(new Date(), "YYYY-MM-DD"));
        }
        if(!component.get("v.StandardOrderLines.sigmaerpdev__Order_Status__c")){
            component.set("v.StandardOrderLines.sigmaerpdev__Order_Status__c", component.get("v.standOrder.sigmaerpdev__Orders_Status__c"));
        }
        
        
    },
    handleAccountIdUpdate : function(cmp, event, helper) {
        var productID = event.getParam("sObjectId");
        //alert('productID'+productID);
        var customerAccountID = event.getParam("sObjectIdNew");
        var instanceId = event.getParam("instanceId");
        if(instanceId === "MyProduct")
            
        {
            cmp.set('v.StandardOrderLines.sigmaerpdev__Product__c', productID);
            
            if(cmp.get('v.StandardOrderLines.sigmaerpdev__Product__c')){
                helper.getProductDataEdit(cmp, event, helper, cmp.get("v.StandardOrderLines.sigmaerpdev__Product__c"));
            }
        }
    },
    selectMalually: function (component, event, helper) {
        
        if(component.get("v.StandardOrderLines.sigmaerpdev__Product__c")==undefined || component.get("v.StandardOrderLines.sigmaerpdev__Product__c")==='')
        {
            alert('Product Not Selected');
            return;
        }
        if(component.get("v.StandardOrderLines.sigmaerpdev__Net_Quantity__c")==undefined || component.get("v.StandardOrderLines.sigmaerpdev__Net_Quantity__c")==='' || component.get("v.sigmaOrderLines.sigmaerpdev__Net_Quantity__c")<1)
        {
            alert('Enter a Valid Quantity');
            return;
        } 
        var StandOrderCmpEvent = component.getEvent("StandOrderCmpEvent");
        StandOrderCmpEvent.setParams({
            "data" : {"index":component.get('v.indexNum')},//"AttributeType":component.get("v.productPrices")[0].stapp__Attribute_Type__c},
            "flag" : "manualSelectILPLI"
        });
        StandOrderCmpEvent.fire();
    },
    autoPickInventory: function (component, event, helper) {
        
        if(component.get("v.StandardOrderLines.sigmaerpdev__Product__c")==undefined || component.get("v.StandardOrderLines.sigmaerpdev__Product__c")==='')
        {
            alert('Product Not Selected');
            return;
        }
        if(component.get("v.StandardOrderLines.sigmaerpdev__Net_Quantity__c")==undefined || component.get("v.StandardOrderLines.sigmaerpdev__Net_Quantity__c")==='' || component.get("v.orderLines.sigmaerpdev__Net_Quantity__c")<1)
        {
            alert('Enter a Valid Quantity');
            return;
        } 
        var StandOrderCmpEvent = component.getEvent("StandOrderCmpEvent");
        StandOrderCmpEvent.setParams({
            "data" : {"index":component.get('v.indexNum')},
            "flag" : "autoPickILPLI"
        });
        StandOrderCmpEvent.fire();
    },
    
    updateOrderQuantity: function (component, event, helper) {
        
        component.set("v.StandardOrderLines.sigmaerpdev__Quantity__c", parseInt(component.get("v.StandardOrderLines.sigmaerpdev__Net_Quantity__c")));
        component.set("v.StandardOrderLines.sigmaerpdev__Total_Price__c", parseInt((component.get("v.StandardOrderLines.sigmaerpdev__Net_Quantity__c")) * (component.get("v.StandardOrderLines.sigmaerpdev__Total_Amount__c"))));
        if (component.get("v.StandardOrderLines.sigmaerpdev__Quantity__c") > component.get("v.availableQuantity")) 
        {
            helper.handleBackOrder(component, event, helper);
        }
        
    },
    updateTotalPrice:function (component, event, helper){
        if(!component.get("v.StandardOrderLines.sigmaerpdev__Discounts__c"))
        {
            component.set("v.StandardOrderLines.sigmaerpdev__Discounts__c",0);
        }
         if(component.get("v.StandardOrderLines.sigmaerpdev__Discounts__c") >=component.get("v.maxdiscount")){
            alert('Discount Should not greater than MaxDiscount of Product,MaxDiscount:'+component.get("v.maxdiscount"));
              component.set('v.StandardOrderLines.sigmaerpdev__Discounts__c',null);
         //   cmp.set('v.productAmount',total1);
           // return;
        }
        else
        {
        // component.set("v.StandardOrderLines.sigmaerpdev__Total_Price__c",parseInt((component.get("v.StandardOrderLines.sigmaerpdev__Total_Price__c"))-((component.get("v.StandardOrderLines.sigmaerpdev__Total_Price__c"))*(component.get("v.StandardOrderLines.sigmaerpdev__Discounts__c")/100))));
        var totalprice=parseInt((component.get("v.StandardOrderLines.sigmaerpdev__Net_Quantity__c")) * (component.get("v.StandardOrderLines.sigmaerpdev__Total_Amount__c")));   
        component.set("v.StandardOrderLines.sigmaerpdev__Total_Price__c",parseInt(totalprice-(totalprice*(component.get("v.StandardOrderLines.sigmaerpdev__Discounts__c")/100))));
      //  alert('final Amount'+component.get("v.StandardOrderLines.sigmaerpdev__Total_Price__c"));
        }
    },
    removeOrderLines: function (component, event, helper) {
        var StandOrderCmpEvent = component.getEvent("StandOrderCmpEvent");
        StandOrderCmpEvent.setParams({
            "data": {
                "index": component.get('v.indexNum')
            },
            "flag": "removeOrderLine"
        });
        StandOrderCmpEvent.fire();
    },
    handleProductIdValueChange: function (component, event, helper) {
        // alert('Inside hnadler');
        var ol=component.get('v.StandardOrderLines');
        if(ol){
            // alert('innn');
            if(!component.get('v.productName')){
               // alert('remove');
                // component.set('v.StandardOrderLines.sigmaerpdev__Product__c','')
                component.set('v.StandardOrderLines.sigmaerpdev__Net_Quantity__c',0);
                component.set('v.StandardOrderLines.sigmaerpdev__Quantity__c',0);
                component.set('v.availableQuantity',0);
                component.set('v.StandardOrderLines.sigmaerpdev__Total_Amount__c',0);
                component.set('v.StandardOrderLines.sigmaerpdev__Discounts__c',0);
                component.set('v.StandardOrderLines.sigmaerpdev__Total_Price__c',0);
                var idListStr=component.get('v.idListStr');
                if(idListStr)
                    idListStr = idListStr.replace(event.getParam("oldValue"), "");
                component.set('v.idListStr',idListStr)
            }
        }
        //else{
        //}
    }
    
})
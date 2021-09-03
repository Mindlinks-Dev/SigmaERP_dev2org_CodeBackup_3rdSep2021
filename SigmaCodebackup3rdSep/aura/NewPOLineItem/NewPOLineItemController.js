({
     doInit : function(component, event, helper) {
        helper.fetchPickListVal(component, 'sigmaerpdev2__Status__c', 'statuspop');
    },
    onPicklistChange: function(component, event, helper) {
        // get the value of select option
        event.getSource().get("v.value");
    },
    save : function(component, event, helper){
        //alert('hiii');
        
        var popData = component.get("v.popData");
        //alert("popData>>>>>>>>>>>>>>>>"+JSON.stringify(popData));
        var AddPOLineItem = component.getEvent("AddPOLineItem");
        AddPOLineItem.setParams({
            AddPOLineItem:popData
        });
        //alert('UpdatePOLineItem inside');
        //alert('UpdatePOLineItem:'+AddPOLineItem);
        AddPOLineItem.fire();
        
        /*var popData = component.get("v.popData");
        alert(JSON.stringify(popData));
        var action= component.get("c.savepop");
        
        action.setParams({
            pop:popData
        });
        //alert(JSON.stringify(action));
        action.setCallback(this, function(response){
            var state = response.getState();
            alert("state>>>>>>>>>>>>>>>>>>>>>>>>>"+state);
            var respo = response.getReturnValue();
            alert("respo>>>>>>>>>>>>>>>>"+JSON.stringify(respo));
            if (component.isValid() && state === "SUCCESS"){
                
                alert('success');
                var AddPOLineItem = component.getEvent("AddPOLineItem");
                AddPOLineItem.setParams({
                    AddPOLineItem:respo
                });
                //alert('UpdatePOLineItem inside');
                //alert('UpdatePOLineItem:'+AddPOLineItem);
                AddPOLineItem.fire();
                // $A.get("e.force:closeQuickAction").fire()
                //helper.doSave(component, event, helper,respo);
            }
        });
        $A.enqueueAction(action);*/
        
    },
    cancel : function(component, event, helper){
        component.set('v.savepop',false);
        component.set('v.podetails',true);
    },
    handleKeyUp: function (cmp, evt) {
        var isEnterKey = evt.keyCode === 13;
        if (isEnterKey) {
            var queryTerm = cmp.find('enter-search').get('v.value');
            // alert('Searched for "' + queryTerm + '"!');
        }
    },
    
    
    validateQuantity : function (cmp,event){
        
        var  productid=cmp.get("v.popData.sigmaerpdev2__Product__c");
        var qty = cmp.get("v.popData.sigmaerpdev2__Quantity__c");
        var vendorId=cmp.get("v.PurchaseOrderData.sigmaerpdev2__Product_Supplier__c");
        var action= cmp.get("c.getBuyingPrice");
        action.setParams({
            productid:productid,
            vendorId:vendorId
        });
        //alert('hii again');
        //alert(JSON.stringify(action));
        action.setCallback(this, function(response){
            var state = response.getState();
            //alert("state>>>>>>>>>>>>>>>>>>>>>>>>>"+state);
            var respo = response.getReturnValue();
            //alert("respo>>>>>>>>>>>>>>>>"+JSON.stringify(respo));
            if (cmp.isValid() && state === "SUCCESS"){
                
                //alert(respo.sigmaerpdev2__Buying_Price__c);
                var quantity=cmp.get("v.popData.sigmaerpdev2__Quantity__c");
                var  prodid=cmp.get("v.popData.sigmaerpdev2__Product__c");
                var  discount=cmp.get("v.popData.sigmaerpdev2__Discount__c");
                
                
                if(discount==null){
                    var totalqty=quantity*respo.sigmaerpdev2__Buying_Price__c;
                    cmp.set("v.popData.Product_name",respo.sigmaerpdev2__Product_Name__r.Name);
                    cmp.set("v.popData.sigmaerpdev2__Buying_Price__c",totalqty);
                    cmp.set("v.popData.sigmaerpdev2__Total_Buying_Price__c",totalqty);
                    cmp.set("v.popData.sigmaerpdev2__VendorPrice__c",respo.sigmaerpdev2__Buying_Price__c);
                }
                else{
                    var totalqty=(respo.sigmaerpdev2__Buying_Price__c-(respo.sigmaerpdev2__Buying_Price__c*(discount/100)))*quantity;
                    var totalqty1=quantity*respo.sigmaerpdev2__Buying_Price__c;
                    cmp.set("v.popData.Product_name",respo.sigmaerpdev2__Product_Name__r.Name);
                    cmp.set("v.popData.sigmaerpdev2__Buying_Price__c",totalqty);
                    cmp.set("v.popData.sigmaerpdev2__Total_Buying_Price__c",totalqty);
                    cmp.set("v.popData.sigmaerpdev2__VendorPrice__c",respo.sigmaerpdev2__Buying_Price__c);
                }
                /*var totalqty=quantity*respo.sigmaerpdev2__Buying_Price__c;
                cmp.set("v.popData.Product_name",respo.sigmaerpdev2__Product_Name__r.Name);
                cmp.set("v.popData.sigmaerpdev2__Buying_Price__c",totalqty);
                cmp.set("v.popData.sigmaerpdev2__Total_Buying_Price__c",totalqty);
                cmp.set("v.popData.sigmaerpdev2__VendorPrice__c",respo.sigmaerpdev2__Buying_Price__c);*/
                //alert('ttl'+totalqty);
                //helper.doSave(component, event, helper,respo);
            }
        });
        $A.enqueueAction(action);
    }
})
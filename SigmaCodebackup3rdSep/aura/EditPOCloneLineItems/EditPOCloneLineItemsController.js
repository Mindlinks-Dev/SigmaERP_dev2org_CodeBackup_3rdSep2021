({
    doInit : function(component, event, helper) {
        helper.fetchPickListVal(component, 'sigmaerpdev2__Status__c', 'statuspop');
        helper.doInit(component, event, helper)
    },
    onPicklistChange: function(component, event, helper) {
        // get the value of select option
        event.getSource().get("v.value");
    },
    cancel : function(component, event, helper){
        component.set('v.popup',false);
        component.set('v.podetails',true);
    },
    update : function(component, event, helper){
        //alert('hii');
        var pop=component.get('v.popDetails');
        //alert(pop);
        var action= component.get("c.updatepop");
        //alert(JSON.stringify(action));
        action.setParams({
            pop:pop,
        });
        //alert(JSON.stringify(action));
        action.setCallback(this, function(response){
            var state = response.getState();
            //alert("state>>>>>>>>>>>>>>>>>>>>>>>>>"+state);
            var respo = response.getReturnValue();
            //alert("respo>>>>>>>>>>>>>>>>"+JSON.stringify(respo));
            
            if (component.isValid() && state === "SUCCESS"){
                if(respo !=null){
                    //alert('success respo>>'+JSON.stringify(respo));
                    // component.set('v.popDetails',respo);
                    /*var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success",
                        "type":"success",
                        "message": "Successfully updated....."
                    });
                    toastEvent.fire();*/
                    component.set('v.popup',false);
                    component.set('v.podetails',true);
                    var UpdatePOLineItem = component.getEvent("UpdatePOLineItem");
                    /*cmpEvent.setParams({
                        updatepop:respo
                    });*/
                    //alert('UpdatePOLineItem inside');
                    // alert('UpdatePOLineItem:'+UpdatePOLineItem);
                    UpdatePOLineItem.fire();
                    //$A.get('e.force:refreshView').fire();
                }
                
            }
        });
        $A.enqueueAction(action);
    },
    handleKeyUp: function (cmp, evt) {
        var isEnterKey = evt.keyCode === 13;
        if (isEnterKey) {
            var queryTerm = cmp.find('enter-search').get('v.value');
            // alert('Searched for "' + queryTerm + '"!');
        }
    },
    validateQuantity : function (cmp,event){
        
        var  productid=cmp.get("v.popDetails.sigmaerpdev2__Product__c");
        var qty = cmp.get("v.popDetails.sigmaerpdev2__Quantity__c");
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
                
                //alert(respo.sigmaerpdev__Buying_Price__c);
                var quantity=cmp.get("v.popDetails.sigmaerpdev2__Quantity__c");
                var  prodid=cmp.get("v.popDetails.sigmaerpdev2__Product__c");
                var  discount=cmp.get("v.popDetails.sigmaerpdev2__Discount__c");
                if(discount==null){
                    var totalqty=quantity*respo.sigmaerpdev2__Buying_Price__c;
                    cmp.set("v.popDetails.Product_name",respo.sigmaerpdev2__Product_Name__r.Name);
                    cmp.set("v.popDetails.sigmaerpdev2__Buying_Price__c",totalqty);
                    cmp.set("v.popDetails.sigmaerpdev2__Total_Buying_Price__c",totalqty);
                    cmp.set("v.popDetails.sigmaerpdev2__VendorPrice__c",respo.sigmaerpdev2__Buying_Price__c);
                }
                else{
                    var totalqty=(respo.sigmaerpdev2__Buying_Price__c-(respo.sigmaerpdev2__Buying_Price__c*(discount/100)))*quantity;
                    var totalqty1=quantity*respo.sigmaerpdev2__Buying_Price__c;
                    cmp.set("v.popDetails.Product_name",respo.sigmaerpdev2__Product_Name__r.Name);
                    cmp.set("v.popDetails.sigmaerpdev2__Buying_Price__c",totalqty);
                    cmp.set("v.popDetails.sigmaerpdev2__Total_Buying_Price__c",totalqty);
                    cmp.set("v.popDetails.sigmaerpdev2__VendorPrice__c",respo.sigmaerpdev2__Buying_Price__c);
                }
                
                //alert('ttl'+totalqty);
                //helper.doSave(component, event, helper,respo);
            }
        });
        $A.enqueueAction(action);
    }
})
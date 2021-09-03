({
    doInit : function(component, event, helper) {
        // alert('doInit');
        var recordId = component.get("v.purchaseOrderIdForClone");
        //alert('ooooo'+recordId);
        
        var action = component.get("c.getCloningDetails");
        action.setParams({
            purchaseId:component.get("v.recordId")
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            //alert(state);
            if (component.isValid() && state === "SUCCESS"){
                var resultData = result.getReturnValue();
                //alert(resultData.sigmaerpdev__Product_Supplier__c);
                //alert(resultData.sigmaerpdev__Product_Supplier__r.Name);
                component.set("v.poid",resultData.Name);
                component.set("v.PurchaseOrderData",resultData);
                //alert('PONAme'+component.get("v.poid"));
                var value=component.get("v.poid");
                //alert('todoinit');
                helper.doInitAgain(component, event, helper);
            }
        });
        $A.enqueueAction(action);
        
    },
    doInitAgain : function(component, event, helper) {
        
        //alert('Getlost'+component.get("v.poid"));
        var action1 = component.get("c.getLineItems");
        
        action1.setParams({
            purchaseId:component.get("v.poid")
        });
        
        action1.setCallback(this, function(result) {
            //alert('olage bande');
            var state = result.getState();
            //alert(state);
            //alert('for order line<<<'+result.getReturnValue());
            if (component.isValid() && state === "SUCCESS"){
                var resultData = result.getReturnValue();
                //alert(JSON.stringify(resultData));
                //component.set("v.lineItem",resultData);
                component.set('v.lineItem',resultData);
                //alert(JSON.stringify(component.get("v.popid")));
            }
        });
        $A.enqueueAction(action1);
    },
    
    fetchPickListVal: function(component, fieldName, elementId) {
        var action = component.get("c.getselectOptions");
        action.setParams({
            "objObject": component.get("v.objInfo"),
            "fld": fieldName
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                
                if (allValues != undefined && allValues.length > 0) {
                    opts.push({
                        class: "optionClass",
                        label: "--- None ---",
                        value: ""
                    });
                }
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                component.find(elementId).set("v.options", opts);
            }
        });
        $A.enqueueAction(action);
    },
    
    removePOHelper : function(component, event, helper,index){
        var purchaseOrderList = component.get("v.lineItem");
        var i=index;
        purchaseOrderList.splice(index, 1);
        component.set("v.lineItem", purchaseOrderList);
    },
    editPOHelper : function(component, event, helper){
        /*var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
             "recordId": event.target.id
       });
       editRecordEvent.fire();*/
        //var whichOne = event.getSource().getLocalId();
        //alert(event.target.id);
        component.set('v.popid',event.target.id);
        /* console.log(whichOne);
        cmp.set("v.whichButton", whichOne);*/
        component.set('v.popup',true);
        component.set('v.podetails',false);
        
    },
    doSave : function(component, event, helper,respo){
        var lineItem = component.get("v.lineItem");
        //alert(JSON.stringify(lineItem));
        var action= component.get("c.saveLI");
        //alert(JSON.stringify(action));
        action.setParams({
            pop:lineItem,
            purchaseId:respo
        });
        //alert(JSON.stringify(action));
        action.setCallback(this, function(response){
            var state = response.getState();
            //alert("state>>>>>>>>>>>>>>>>>>>>>>>>>"+state);
            var result = response.getReturnValue();
            //alert("respo>>>>>>>>>>>>>>>>"+JSON.stringify(respo));
            
            if (component.isValid() && state === "SUCCESS"){
                if(result !=null){
                    //alert('success respo>>'+JSON.stringify(result));
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success",
                        "type":"success",
                        "message": "Successfully saved....."
                    });
                    toastEvent.fire();
                    
                }
                
            }
        });
        $A.enqueueAction(action);
    },
    handleAddPO : function(component, event, helper){
        var NewLineItem = event.getParam("AddPOLineItem");
        //alert("NewLineItem>>>>>>>>>>>>>>>>>>>>>>>>>"+JSON.stringify(NewLineItem));
        var lineItem = component.get("v.lineItem");
        //alert("LineItem>>>>>>>>>>>>>>>>>>>>>>>>>"+JSON.stringify(lineItem));
        
        lineItem.push(NewLineItem);            
        component.set('v.savepop',false);
        component.set('v.podetails',true);
    }
})
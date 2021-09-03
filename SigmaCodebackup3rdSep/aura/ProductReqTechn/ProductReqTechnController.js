({
	doInit : function(component, event, helper) { 
        //alert('init');
        helper.displayField_helper(component, event, helper);    
    },
    
    selValue : function(component, event, helper){
        var selVal = component.find("statVal").get("v.value");
        component.set("v.SMData.prObject.sigmaerpdev2__Status__c", selVal);
    },
    
    addNewProds : function(component, event, helper){
        if(component.get("v.SMData.ListOfProdReqLIs") == null){
             var wrap = [{
                    'prodID': '',
                    'reqQty' : ''
                }];
           	 component.set("v.SMData.ListOfProdReqLIs", wrap);
        }else{
            var wrap = {
                'prodID': '',
                'reqQty' : ''
            };
            var temp = component.get("v.SMData.ListOfProdReqLIs");            
            temp.push(wrap);
            component.set("v.SMData.ListOfProdReqLIs", temp);
        }
    },
    
    handleRemove: function (component, event, helper) {
        var index = event.currentTarget.dataset.index;
        var row = component.get("v.SMData.ListOfProdReqLIs");
        row.splice(index,1);
        component.set("v.SMData.ListOfProdReqLIs",row);      
    },
    
    saveProdRequest : function(component, event, helper){
        if(component.get("v.SMData.prObject.sigmaerpdev2__Status__c") == undefined){
            component.set("v.SMData.prObject.sigmaerpdev2__Status__c", "Draft");
        }
        var nDate = component.get("v.SMData.prObject.sigmaerpdev2__Need_by_Date__c");
        var AllData = component.get("v.SMData.ListOfProdReqLIs");
        if(nDate == '' || nDate == undefined){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "warning",
                "title": "Warning!",
                "message": "Choose a value for Need by Date."
            });
            toastEvent.fire();
            return;
        }
        for(var i=0;i<AllData.length;i++){
            if(AllData[i].prodID == '' || AllData[i].prodID == undefined){
               	var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "warning",
                    "title": "Warning!",
                    "message": "Choose a value for Product @row number : "+(i+1)
                });
                toastEvent.fire();
                return; 
            }
            if(AllData[i].reqQty == '' || AllData[i].reqQty == undefined){
               	var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "warning",
                    "title": "Warning!",
                    "message": "Choose a value for Required Quantity @row number : "+(i+1)
                });
                toastEvent.fire();
                return; 
            }
        }
        helper.saveDetails(component, event, helper);
    },
    
    updateProdRequest : function(component, event, helper){
        var nDate = component.get("v.SMData.prObject.sigmaerpdev2__Need_by_Date__c");
        var AllData = component.get("v.SMData.ListOfProdReqLIs");
        if(nDate == '' || nDate == undefined){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "warning",
                "title": "Warning!",
                "message": "Choose a value for Need by Date."
            });
            toastEvent.fire();
            return;
        }
        for(var i=0;i<AllData.length;i++){
            if(AllData[i].prodID == '' || AllData[i].prodID == undefined){
               	var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "warning",
                    "title": "Warning!",
                    "message": "Choose a value for Product @row number : "+(i+1)
                });
                toastEvent.fire();
                return; 
            }
            if(AllData[i].reqQty == '' || AllData[i].reqQty == undefined){
               	var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "warning",
                    "title": "Warning!",
                    "message": "Choose a value for Required Quantity @row number : "+(i+1)
                });
                toastEvent.fire();
                return; 
            }
        }
        helper.updateDetails(component, event, helper);
    },
    
    cancelProdRequest : function(component, event, helper){
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:PRMain"
        });
        evt.fire();
    }    
})
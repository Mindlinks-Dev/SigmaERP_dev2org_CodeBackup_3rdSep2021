({
	 displayField_helper : function(component, event, helper) {
       
        var recordId = component.get("v.recID1");
        //alert('recordId>'+recordId);
        if(recordId != null){
            var spinner = component.find("mySpinner");
		    $A.util.toggleClass(spinner, "slds-hide");
        	var action = component.get("c.editValues");
            action.setParams({ 
                "recId": recordId
            });
            action.setCallback(this, function(response) {
               // alert('response.getState()>>'+response.getState());
                if(response.getState() == "SUCCESS"){
                   var allValues = response.getReturnValue();
                 //   alert('response.getReturnValue()>>'+response.getReturnValue());
                   component.set("v.SMData", allValues);
                   var stat = allValues.prObject.sigmaerpdev2__Status__c;
                   component.set("v.selectedStatus", stat);
                }
                var spinner = component.find("mySpinner");
		    	$A.util.toggleClass(spinner, "slds-hide");
            });
            $A.enqueueAction(action);      
        }else{
        	var action = component.get("c.getInitValues");
            action.setCallback(this, function(response) {
                //alert('error==='+JSON.stringify(response.getError()));
                if(response.getState() == "SUCCESS"){
                    var allValues = response.getReturnValue();
                    component.set("v.SMData", allValues);
                    var wrap = [{
                        'prodID': '',
                        'reqQty' : ''
                    }];
                    component.set("v.SMData.ListOfProdReqLIs", wrap);
                }    
            });
            $A.enqueueAction(action);    
        }       
    },
    
    saveDetails : function(component, event, helper){
        var AllData = component.get("v.SMData");
        delete AllData.pickVals;
        var action = component.get("c.savePRDetails");
        action.setParams({ 
            "reqData": JSON.stringify(AllData)
        });
        action.setCallback(this, function(response) {
            if(response.getState() == "SUCCESS"){
                var returnMsg = response.getReturnValue();
                if(returnMsg == 'success'){
                	var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "success",
                        "title": "Success!",
                        "message": "Product request record has been created successfully."
                    });
                    toastEvent.fire();
                    var evt = $A.get("e.force:navigateToComponent");
                    evt.setParams({
                        componentDef : "c:PRMain"
                    });
                    evt.fire();
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "error",
                        "title": "Error!",
                        "message": returnMsg
                    });
                    toastEvent.fire(); 
                }
            }    
        });
        $A.enqueueAction(action);   
    },
    
    updateDetails : function(component, event, helper){
        var AllData = component.get("v.SMData");
        delete AllData.pickVals;
        var action = component.get("c.updatePRDetails");
        action.setParams({ 
            "reqData": JSON.stringify(AllData),
            "recID" : component.get("v.recID1")
        });
        action.setCallback(this, function(response) {
            if(response.getState() == "SUCCESS"){
                var returnMsg = response.getReturnValue();
                if(returnMsg == 'success'){
                	var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "success",
                        "title": "Success!",
                        "message": "Product request record has been updated successfully."
                    });
                    toastEvent.fire(); 
                    var evt = $A.get("e.force:navigateToComponent");
                    evt.setParams({
                        componentDef : "c:PRMain"
                    });
                    evt.fire();
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "error",
                        "title": "Error!",
                        "message": returnMsg
                    });
                    toastEvent.fire(); 
                }
            }    
        });
        $A.enqueueAction(action); 
    }
     
})
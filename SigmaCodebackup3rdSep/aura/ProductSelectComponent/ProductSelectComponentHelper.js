({
    checkProductRequestStatusHelper : function(cmp,event) {
        debugger;
        // create a one-time use instance of the serverEcho action
        // in the server-side controller
        
        var action = cmp.get("c.checkProductReqStatus");
        action.setParams({ recordId :cmp.get('v.recordId') });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var responseData = response.getReturnValue();
                if(responseData == 'success'){
                    cmp.set('v.isTrue',true);
                    //cmp.set('v.isFalse',false);
                }
                else if(responseData == 'failure'){
                    
                    cmp.set('v.isFalse',true);
                }
                
                // You would typically fire a event here to trigger 
                // client-side notification that the server-side 
                // action is complete
            } else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        // optionally set storable, abortable, background flag here
        
        // A client-side action could cause multiple events, 
        // which could trigger other events and 
        // other server-side action calls.
        // $A.enqueueAction adds the server-side action to the queue.
        $A.enqueueAction(action);
    },
    
    
	 createProductTransferHelper : function(cmp,event) {
        //debugger;
         
        // create a one-time use instance of the serverEcho action
        // in the server-side controller
        var wrappdataList = cmp.get("v.wrappdatas");
        //var interimListUpdated = JSON.stringify(wrappdataList).replace(/""/g, '"0"'); //convert to JSON string 
        var interimListUpdated = JSON.stringify(wrappdataList);      
        //alert('interimListUpdated===='+JSON.stringify(interimListUpdated));
        
        var action = cmp.get("c.createProductTrans");
        action.setParams({ 
            "recordId" : cmp.get('v.recordId'),
            "selJsonStr" :  interimListUpdated      
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var responseData = response.getReturnValue();
                if(responseData == 'success'){
                    cmp.set('v.isTrue',true);
                    cmp.set('v.isFalse',false);
                    var toastEvent = $A.get("e.force:showToast");
                    console.log(response.getReturnValue());
                    console.log('success');
                    toastEvent.setParams({
                        title: "Success",
                        type: "success",
                        message: "Product Transfer created Successfully!"
                    });
                    window.location.reload();
                    $A.get("e.force:closeQuickAction").fire();
                    toastEvent.fire();
                }
                else if(responseData == 'failure'){
                    cmp.set('v.isTrue',false);
                    cmp.set('v.isFalse',true);
                    var toastEvent = $A.get("e.force:showToast");
                    console.log(response.getReturnValue());
                    console.log('faliure');
                    toastEvent.setParams({
                        title: "",
                        type: "Error",
                        message: "Product Request has to be Approved.",
                        mode:"sticky"
                    });
                    toastEvent.fire();
                }
                    else if(responseData == 'fail'){
                        cmp.set('v.isTrue',false);
                        cmp.set('v.isFalse',true);
                        var toastEvent = $A.get("e.force:showToast");
                        console.log(response.getReturnValue());
                        console.log('faliure');
                        toastEvent.setParams({
                            title: "",
                            type: "Error",
                            message: "Product Transfer has already been created.",
                            mode:"sticky"
                        });
                        toastEvent.fire();
                    }
                        else if(responseData='No Product Line Items'){
                            var toastEvent = $A.get("e.force:showToast");
                            console.log(response.getReturnValue());
                            console.log('faliure');
                            toastEvent.setParams({
                                title: "",
                                type: "Error",
                                message: "There are no Product Request Line Items to create a Transfer.",
                                mode:"sticky"
                            });
                            toastEvent.fire();
                        }
                            else{
                                //cmp.set('v.isTrue',false);
                            }
                
                // You would typically fire a event here to trigger 
                // client-side notification that the server-side 
                // action is complete
            } else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        // optionally set storable, abortable, background flag here
        
        // A client-side action could cause multiple events, 
        // which could trigger other events and 
        // other server-side action calls.
        // $A.enqueueAction adds the server-side action to the queue.
        $A.enqueueAction(action);
    },
})
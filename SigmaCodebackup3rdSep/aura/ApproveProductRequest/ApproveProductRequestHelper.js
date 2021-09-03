({
    approveProductRequestHelper : function(cmp,event) {
       debugger;
        // create a one-time use instance of the serverEcho action
        // in the server-side controller
        
        var action = cmp.get("c.approveProductReq");
        action.setParams({ productRequestId :cmp.get('v.recordId') });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                
                if(response.getReturnValue() == "success" || response.getReturnValue() == "Success"){
                    //component.set('v.isComplete',true);
                    console.log('success');
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: "Success",
                        type: "success",
                        message: "Approved!"
                    });
                    window.location.reload();
                    $A.get("e.force:closeQuickAction").fire();
                }
                else if(response.getReturnValue() == 'failure'){
                    cmp.set('v.isTrue',false);
                    var toastEvent = $A.get("e.force:showToast");
                    console.log(response.getReturnValue());
                    console.log('faliure');
                    toastEvent.setParams({
                        title: "",
                        type: "Error",
                        message: "Product Request has already been Approved.",
                        mode:"sticky"
                    });
                    toastEvent.fire();
                }
                 else if(response.getReturnValue() == 'failure1'){
                    cmp.set('v.isTrue',false);
                    var toastEvent = $A.get("e.force:showToast");
                    console.log(response.getReturnValue());
                    console.log('faliure');
                    toastEvent.setParams({
                        title: "",
                        type: "Error",
                        message: "Product Request is not in submitted status.",
                        mode:"sticky"
                    });
                    toastEvent.fire();
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
        debugger;
        // create a one-time use instance of the serverEcho action
        // in the server-side controller
        
        var action = cmp.get("c.createProductTrans");
        action.setParams({ recordId :cmp.get('v.recordId') });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var responseData = response.getReturnValue();
                if(responseData == 'success'){
                    cmp.set('v.isTrue',true);
                    var toastEvent = $A.get("e.force:showToast");
                    console.log(response.getReturnValue());
                    console.log('success');
                    toastEvent.setParams({
                        title: "Success",
                        type: "Product Transfer created",
                        message: "Work Order Completed Successfully!"
                    });
                    window.location.reload();
                    $A.get("e.force:closeQuickAction").fire();
                    toastEvent.fire();
                }
                else if(responseData == 'failure'){
                    cmp.set('v.isTrue',false);
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
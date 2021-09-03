({
    doInitHelper : function(cmp,event) {
        debugger;
        
        var action = cmp.get("c.getPicklistTerritories");
        //action.setParams({ fromDateString :cmp.get('v.fromDate'), toDateString:temp,arrDateString:cmp.get('v.arrDate') });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
               
                var responseData = response.getReturnValue();
                if(responseData==null){
                    
                }
                else{
                    cmp.set('v.productPicklistvalues',responseData);
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
    getWOADetails : function(cmp,event) {
        debugger;
        
        var action = cmp.get("c.getWorkOrderAssignments");
        action.setParams({ territory:cmp.get('v.picklistValue'),dateString:cmp.get('v.fromDate') });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
               
                var responseData = response.getReturnValue();
                if(responseData==null){
                    cmp.set('v.isPast',false);
                    cmp.set('v.isOpen',true);                    
                    cmp.set('v.message','No Work Orders Assigned');
                }
                else{
                    
                    var convert_array = Object.entries(responseData);
                    var map1 = new Map(convert_array);
                    cmp.set('v.techScheduleDetails',responseData);
                    var arrayOfMapKeys = [];
                    arrayOfMapKeys = Array.from(map1.keys());
                    cmp.set('v.isOpen',true);
                    if(arrayOfMapKeys.length==0){
                          
                    }
                    else{
                        cmp.set('v.techNames',arrayOfMapKeys);
                        
                        cmp.set('v.isOpen',false);
                    }
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
    }
})
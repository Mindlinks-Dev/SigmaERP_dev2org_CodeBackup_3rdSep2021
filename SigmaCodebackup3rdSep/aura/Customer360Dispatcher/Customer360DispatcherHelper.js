({	getDataHelper : function(cmp,event) {
    debugger;
    
    var action = cmp.get("c.getWorkOrderData");
    action.setParams({ recordId:cmp.get('v.recordId') });
    action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === "SUCCESS") {
            
            var responseData = response.getReturnValue();
            if(responseData==null){
                
            }
            else if(responseData.lastVisitDate == "NA"){
                cmp.set('v.workOrderDetails',responseData);
                cmp.set('v.isPastWorkOrders',true);
                cmp.set('v.message','No Work Orders in the past.');
            }
            
                else{
                    cmp.set('v.workOrderDetails',responseData);
                    var pincode = cmp.get('v.workOrderDetails.customerPincode');
                    cmp.set('v.mapMarkers', [
                        {
                            location: {
                                "PostalCode": pincode
                            },
                            
                            title: cmp.get('v.workOrderDetails.name'),
                            description: ''
                        }
                    ]);
                    cmp.set('v.zoomLevel', 16);
                }
            debugger;
            var leastServiceRating = 7;
            var serviceRating = cmp.get('v.workOrderDetails.lastVisitServiceRating');
            if(serviceRating != 'NA'){
                cmp.set('v.sr',true);
                if(parseInt(serviceRating)<leastServiceRating){
                cmp.set('v.colorSR','colorRed');
            }
            else{
                cmp.set('v.colorSR','colorGreen');
            }
            }
            else{
                cmp.set('v.sr',false);
            }
            
            
            var averageServiceRating = cmp.get('v.workOrderDetails.avgServiceRating');
            if(averageServiceRating != 'NA'){
                cmp.set('v.asr',true);
                if(parseFloat(averageServiceRating)<leastServiceRating){     
                    cmp.set('v.colorASR','colorRed');
                }
                else{ 
                    cmp.set('v.colorASR','colorGreen');
                }
            }
            else{
                cmp.set('v.asr',false);
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
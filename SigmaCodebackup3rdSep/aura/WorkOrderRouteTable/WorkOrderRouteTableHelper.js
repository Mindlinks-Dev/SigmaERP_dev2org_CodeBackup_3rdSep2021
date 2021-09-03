({
    
    getWorkOrdersHelper : function(cmp,event) { 
        
        // debugger;
        //Gets the current location.
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function(position) {
                //Records the latitude of the current location.
                var latit = position.coords.latitude;
                
                //Records the longitude of the current location.
                var longit =position.coords.longitude;
                //alert("lat & long: "+latit+':'+longit);
                cmp.set("v.latitude",latit);
                cmp.set("v.longitude",longit);
                
                
                var action = cmp.get("c.getWorkOrdersDetails");
                
                
                action.setParams({"lat":cmp.get('v.latitude'),"lon":cmp.get('v.longitude') });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                   // alert(state);
                    if (state === "SUCCESS") {
                        var arrayOfMapKeys = [];
                        
                        //Getting the data that is returned from the Apex class.
                        var responseData = response.getReturnValue();
                        //alert('inns'+JSON.stringify(responseData));
                        //If data is null print the corresponding message.
                        if(responseData==null){
                            cmp.set('v.isEmpty',false);
                        }
                        else{
                            cmp.set('v.workOrderDetails',responseData);
                            cmp.set('v.isEmpty',true);
                          /*  var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Success!",
                                "message": "The record has been updated successfully."
                            });
                            toastEvent.fire();*/
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
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                title: "Error",
                                type: "error",
                                message:"",
                                mode : "sticky"
                            });
                            toastEvent.fire();
                        }
                });
                // optionally set storable, abortable, background flag here
                
                // A client-side action could cause multiple events, 
                // which could trigger other events and 
                // other server-side action calls.
                // $A.enqueueAction adds the server-side action to the queue.
                $A.enqueueAction(action);              
            });
        }
        
    }
})
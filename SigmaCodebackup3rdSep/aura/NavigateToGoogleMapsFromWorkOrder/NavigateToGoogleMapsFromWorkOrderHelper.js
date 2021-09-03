({
    openGoogleMapsHelper : function(cmp,event) {
        debugger;
        var serviceStreet = '';
        var serviceCity = '';
        var serviceState = '';
        var servicePincode = '';
        var action = cmp.get("c.getWorkOrderServiceAddress");
        action.setParams({ recordId :cmp.get('v.recordId') });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                //Fetching the data that is getting returned from the Apex.
                var responseData = response.getReturnValue();
                
                if(responseData==null){
                    //if the data is empty, display a corresponding message.
                    cmp.set('v.isEmpty',false);
                    toastEvent.setParams({
                        title: "Error",
                        type: "error",
                        message:"",
                        mode : "sticky"
                    });
                    toastEvent.fire();
                }
                else{
                    
                    if(responseData.serviceStreet!=null){
                        
                        serviceStreet = responseData.serviceStreet;
                    }
                    if(responseData.serviceCity!=null){
                        
                        serviceCity = responseData.serviceCity;
                    }
                    if(responseData.serviceState!=null){
                        
                        serviceState = responseData.serviceState;
                    }
                    if(responseData.servicePincode!=null){
                        
                        servicePincode = responseData.servicePincode;
                    }
                    
                    if (navigator.geolocation) {
                        debugger;
                        navigator.geolocation.getCurrentPosition(function(position) {
                            var latit = position.coords.latitude;
                            var longit = position.coords.longitude;  
                            $A.get("e.force:closeQuickAction").fire();
                            window.open("https://www.google.com/maps/dir/"+latit+","+longit+"/"+serviceStreet+","+serviceCity+","+serviceState+","+servicePincode);
                        });
                    }
                    
                }
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
            //toastEvent.fire();
        });
        // optionally set storable, abortable, background flag here
        
        // A client-side action could cause multiple events, 
        // which could trigger other events and 
        // other server-side action calls.
        // $A.enqueueAction adds the server-side action to the queue.
        $A.enqueueAction(action);
    },
})
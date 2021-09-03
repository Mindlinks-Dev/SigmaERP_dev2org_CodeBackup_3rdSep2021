({
    getProductStockHelper : function(cmp,event) {
		//Fetching the toDate 
        var temp = new Date(cmp.get('v.toDate'));
        //alert(JSON.stringify(temp));
        //Adding a day to the Above date.
        temp.setDate(temp.getDate()+1);
        //JSON.stringify(temp);
        var action = cmp.get("c.getProductStck");
        action.setParams({ fromDateString :cmp.get('v.fromDate'), toDateString:temp,arrDateString:cmp.get('v.arrDate') });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var arrayOfMapKeys = [];
                var toastEvent = $A.get("e.force:showToast");
                
                
                //Fetching the data that is getting returned from the Apex.
                var responseData = response.getReturnValue();
                //alert('responseData>>>'+JSON.stringify(responseData));
                
                /*if(responseData==null){
                    //if the data is empty, display a corresponding message.
                    cmp.set('v.isEmpty',false);
                    toastEvent.setParams({
                        title: "Error",
                        type: "error",
                        message:"",
                        mode : "sticky"
                    });
                    toastEvent.fire();
                }*/
                if(responseData!=null){
                    cmp.set('v.productListDate',responseData);
                    cmp.set('v.isEmpty',true);
                    
                    //Converting the Object into an Array.
                    var convert_array = Object.entries(responseData);
                    
                    //Passing the above array to a map constructor.
                    var map1 = new Map(convert_array);
                    
                    //Fetching all the keys of the above Map.
                    arrayOfMapKeys = Array.from(map1.keys());
                    
                    //If there a are no keys display a corresponding message.
                    if(arrayOfMapKeys.length==0){
                        cmp.set('v.isEmpty',false);
                        cmp.set('v.message','No Products are available for the WorkOrders on this Date.');  
                    }
                   /* else{
                        toastEvent.setParams({
                        title: "Success",
                        type: "success",
                        message: ""
                    });
                    toastEvent.fire();
					}*/
                    cmp.set('v.listProductNames',arrayOfMapKeys);
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
({
	getShipmentList : function(component, event, helper,page) {
		  page = page || 1;        //alert(page);  
      
    var action = component.get("c.fetchShipmentList");    
         //alert(page);
        action.setParams({ pageNumber : page });
        action.setCallback(this, function(response) {
            var state = response.getState();
           //  alert(state);
            if (state === "SUCCESS") {
               // var spinner = component.find("mySpinner");
        		//$A.util.toggleClass(spinner, "slds-hide");
                var accs = response.getReturnValue(); 
               //alert(JSON.stringify(accs));
                component.set('v.total', accs.total);
                component.set('v.page', accs.page);
                component.set('v.pages', Math.ceil(accs.total/accs.pageSize));
                component.set("v.shipmentList",accs.ShipmentList);
            }
            else if (state === "INCOMPLETE") {
                var spinner = component.find("mySpinner");
        		$A.util.toggleClass(spinner, "slds-hide");
                // do something
            }
                else if (state === "ERROR") {
                    var spinner = component.find("mySpinner");
        			$A.util.toggleClass(spinner, "slds-hide");
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
        $A.enqueueAction(action);
	}
})
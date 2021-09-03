({
	customerHelperMethod : function(cmp, event, helper) {
		
        var customerObj = cmp.get('v.cust'); 
        var action = cmp.get('c.StoreCustomer');         
        action.setParams({
            "customerObj" : customerObj
        });
		
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (cmp.isValid() && state === "SUCCESS")
            {
                 var spinners = cmp.find('spinner');
                 $A.util.removeClass(spinners, 'slds-show');	
                 alert('Customer created successfully.');
                  
                 var customerObjectResponse = response.getReturnValue();
                 var CustomerSFId = customerObjectResponse.Id;
                 var CustomerName = customerObjectResponse.Name;
           		 var updateCustomerEvent = cmp.getEvent("customerRegEvent");
        		 updateCustomerEvent.setParams({
                    "CustomerSFId" : CustomerSFId, "CustomerName" : CustomerName
                 });
        
               
                updateCustomerEvent.fire();     
           		 
            }
            else
            {
                alert('Failed to created customer');
                 var spinners1 = cmp.find('spinner');
                 $A.util.removeClass(spinners1, 'slds-show');	
            }
           
         });
                      
        $A.enqueueAction(action); 

	}
})
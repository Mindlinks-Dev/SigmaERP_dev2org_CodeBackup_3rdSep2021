({
	 showInvoicesH : function(component, event, helper){
         alert('Inside Helper');
        var action = component.get("c.getSalesInvoiceForPayment");
        action.setParams({        
            "accId": component.get("v.recordId"),
        });
        action.setCallback(this, function(response) { 
             //var state = response.getState();
           // alert('state::'+state);
            //console.log('resp==='+JSON.stringify(response.getReturnValue()));
            if(response.getReturnValue() != '' && response.getReturnValue() != null){
                var accountaddress=response.getReturnValue();
                   alert(JSON.stringify(accountaddress));
                component.set("v.SigmaOrderSalesInvoice",response.getReturnValue());
              
               
               
            }  
        });
        $A.enqueueAction(action);  
		
	}
})
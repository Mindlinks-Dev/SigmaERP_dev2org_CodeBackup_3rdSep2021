({
	helperMethod : function() {
		
	},
 
    saveCashPayments : function(component, event)
    {
        
		var cashReceiptNo = component.get('{!v.paymentObj.sigmaerpdev2__ReceiptNumber__c}');   
         var receviedamt = component.get("v.ReceivedAmt");     
       //alert('after set'+receviedamt);
        
        var receivedFrom = component.get("v.receivedFrom");
          
       
        var paymentDate = new Date();
        
        var billAmount = component.get("v.billAmount");
       
        var balance = component.find("balanceDue"); 
        var balanceDue = parseFloat(balance.get('v.value'));
       
        var order_SFId = component.get('v.orderSFId');
       
        var accountSFId = component.get('v.recordId');
       
        var payment = component.get("v.paymentObj");
        //alert('payment>>>'+JSON.stringify(payment));
        payment.sigmaerpdev2__Amount_Recevied__c = receviedamt;
		//payment.sobjectType= 'sigmaerpdev2__Payment__c';  
        console.log('payment>>>'+JSON.stringify(payment));
        
        var action = component.get("c.saveCashPayment");
		action.setParams({
            "payment" : payment
        });
               
        action.setCallback(this, function(response) 
        {
           
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS")
            {           
                
                var returnValues = response.getReturnValue();
               
                if ( returnValues == null || returnValues == '')
                 {    
                          alert('Payment Failed.');
                           return;
                 }
                 alert('Payment done successfully.');
                document.getElementById("Accspinner").style.display = "none";
              
                var transSuccessEvent = component.getEvent("transSuccessEvent");   
                transSuccessEvent.fire();
            }else if (state === "ERROR") {
                     var errors = response.getError();
                	 
                     if (errors) {
                         if (errors[0] && errors[0].message) {
                             alert("Error message is: " + 
                                   errors[0].message);
                         }
                     } else {
                         Console.log("Unknown error");
                     }
            }
         });     
        
         document.getElementById("Accspinner").style.display = "block";
        $A.enqueueAction(action); 
    
	}

})
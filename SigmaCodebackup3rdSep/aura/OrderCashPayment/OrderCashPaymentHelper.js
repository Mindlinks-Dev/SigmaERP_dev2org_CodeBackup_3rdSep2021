({
	saveCashPayments : function(component, event)
    {
                
		var cashReceiptNo = component.get('{!v.paymentObj.sigmaerpdev2__ReceiptNumber__c}');   
        var receviedamt = component.get("v.ReceivedAmt");     
        var payment = component.get("v.paymentObj");
        var order = component.get("v.selectedOrderList");
        var accid = order[0].sigmaerpdev2__AccountId__c;
      //  alert(accid);
        var action = component.get("c.saveCashPayment"); 
        
       // component.set("v.SigmaOrder",order);
        payment.sigmaerpdev2__Amount_Recevied__c = receviedamt;
		payment.sobjectType= 'sigmaerpdev2__Payment__c';  
     
		action.setParams({
            "payment" : payment,
            "order":order
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
             // window.location.href = "/" + accid;
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
    
	},
    savestdCashPayments : function(component, event)
    {
                
		var cashReceiptNo = component.get('{!v.paymentObj.sigmaerpdev2__ReceiptNumber__c}');   
        var receviedamt = component.get("v.ReceivedAmt");     
        var action = component.get("c.savestdCashPayment"); 
        var payment = component.get("v.paymentObj");
        var order = component.get("v.selectedOrderList");
        var acc = order[0].AccountId;
       // component.set("v.SigmaOrder",order);
        payment.sigmaerpdev2__Amount_Recevied__c = receviedamt;
		payment.sobjectType= 'sigmaerpdev2__Payment__c';  
     
		action.setParams({
            "payment" : payment,
            "order":order
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
              // window.location.href = "/" + acc;
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
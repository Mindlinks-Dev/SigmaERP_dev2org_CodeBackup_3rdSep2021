({
	helperMethod : function() {
		
	},
 
    saveCashPayments : function(component, event)
    {
                
		var cashReceiptNo = component.get('{!v.paymentObj.sigmaerpdev2__ReceiptNumber__c}');   
         var receviedamt = component.get("v.ReceivedAmt");     
       // alert('after set'+receviedamt);
        
        var receivedFrom = component.get("v.receivedFrom");
          var cashsub = component.get("v.subpayment");
       
        var paymentDate = new Date();
        
        var billAmount = component.get("v.billAmount");
       
        var balance = component.find("balanceDue"); 
        var balanceDue = parseFloat(balance.get('v.value'));
       
        var order_SFId = component.get('v.orderSFId');
       
        var accountSFId = component.get('v.recordId');
        
     /* if(balanceDue >= 0)
        {
            balance.set("v.errors", [{message:""}]);
             var spinners = component.find('spinner');
             $A.util.removeClass(spinners, 'slds-show');	
            return null;
        }else{
            balance.set("v.errors", null);
        }
        */
        if(cashsub==true)
        {
           
        var action = component.get("c.savesubscriptionCashPayment"); 
        
        var payment = component.get("v.paymentObj");
        component.set("v.paymentlist",payment);
        payment.sigmaerpdev2__Amount_Recevied__c = receviedamt;
		
          var paylist=  component.get("v.paymentlist");
         
		payment.sobjectType= 'sigmaerpdev2__Payment__c';  
     
		action.setParams({
            "payment" : paylist
        });
      

        action.setCallback(this, function(response) 
        {
           
            var state = response.getState();
           
            if (component.isValid() && state === "SUCCESS")
            {           
                
                var returnValues = response.getReturnValue()[0].Id;
              
                 component.set("v.orderSFId",returnValues);
              
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
        }
        else
        {
           
        var action = component.get("c.saveCashPayment"); 
        var payment = component.get("v.paymentObj");
        var regid =   component.get("v.regid"); 
       // alert('regid>>>>/'+regid);
        payment.sigmaerpdev2__Amount_Recevied__c = receviedamt;
		payment.sobjectType= 'sigmaerpdev2__Payment__c';  
     
		action.setParams({
            "payment" : payment,
            "regid" : regid
         });
               
        
     
        action.setCallback(this, function(response) 
        {
           
            var state = response.getState();
          // alert(state);
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
                 alert('Error : '+JSON.stringify(errors));
            
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
        }
         document.getElementById("Accspinner").style.display = "block";
        $A.enqueueAction(action); 
    
	}

})
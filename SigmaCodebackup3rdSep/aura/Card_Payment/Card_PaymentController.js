({
    doInitForCard : function(component, event, helper) 
    {
       
       var payment = component.get("v.paymentObj");
        var receiptNumber = " ";
    	var charset = "abcdefghijklmnopqrstuvwxyz0123456789";
    	for(var i=0; i < 6; i++)
        {
    		receiptNumber += charset.charAt(Math.floor(Math.random() * charset.length));
    	}      
        
        payment.sigmaerpdev2__ReceiptNumber__c = receiptNumber;
        // new code to add the amount paying for card  
        var amount=component.get("v.amountTobeCharged");
        //alert('amount::'+amount);
        if(amount<0)
        {
             var msg = "Complete payment is done for this Order.";
             component.set("v.errorMsg", msg);
             component.set("v.isError",true);
             return;
            
        }
        payment.sigmaerpdev2__Amount__c = component.get("v.amountTobeCharged");
        payment.sigmaerpdev2__Due_Amount__c = component.get("v.amountTobeCharged");
        //alert('payment due ammount::'+payment.sigmaerpdev2__Due_Amount__c);
    },
    
    gotoPaymentOptions : function(component,event,helper)
    {         
        var totalAmount = component.get("v.amountTobeCharged");
        var taxEvent = component.getEvent("taxEventValues");  
        
        taxEvent.setParams({
           
            "amountTobeCharged" :totalAmount
        });
        
        // Fire the event
        taxEvent.fire();
        
    },
    save : function(component, event, helper) {
       
        var cashAmt = component.find("cashReceived").get('v.value');
		
        var validationOfAmount = component.find("cashReceived");
        var cashReceived  = parseFloat(cashAmt);
        component.set("v.ReceivedAmt",cashReceived);
      
		 helper.saveCardPayments(component,event); 
    },
    
    
       
     
    
    checkForCardType : function(component, event, helper)
    {
        var accountNumber = component.get("v.paymentObj.sigmaerpdev2__Credit_CardNumber__c");
       // alert('accountNumber??'+accountNumber);
        accountNumber = accountNumber.replace(/ +/g, ""); //added to remove empty spaces b/w numbers if its pasted instead of typing
       var result = component.get("v.paymentObj.sigmaerpdev2__Credit_CardNumber__c");
        
        if (/^5[1-5]/.test(accountNumber))
        {
            result = "MasterCard";
        }
        
        //then check for Visa
        else if (/^4/.test(accountNumber))
        {
            result = "Visa";
        }
        
        //then check for AmEx
            else if (/^3[47]/.test(accountNumber))
            {
                result = "AmEx";
            }
        
        var temp = result;
         component.set("v.selectedCardType",temp);
       
    }  
    
    
    
    
})
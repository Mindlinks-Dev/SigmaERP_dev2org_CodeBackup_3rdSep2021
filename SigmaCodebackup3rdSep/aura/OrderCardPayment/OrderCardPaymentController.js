({
	doInitForCard : function(component, event, helper) 
    {
        //alert('sigma@@'+component.get('v.SigmaOrder'));
        //alert('StndOrder@@'+component.get('v.StndOrder'));
       var payment = component.get("v.paymentObj");
        var order = component.get('v.selectedOrderList');
        var receiptNumber = " ";
    	var charset = "abcdefghijklmnopqrstuvwxyz0123456789";
    	for(var i=0; i < 6; i++)
        {
    		receiptNumber += charset.charAt(Math.floor(Math.random() * charset.length));
    	} 
        var totalTaxAmount = component.get('v.totalTaxAmount');
        payment.sigmaerpdev2__Tax_Amount__c = totalTaxAmount;
        var fedTax = component.get('v.FederalTax');
        var stateTax = component.get('v.StateTax');
        
        payment.sigmaerpdev2__Federal_Tax__c = fedTax; 
        payment.sigmaerpdev2__State_Tax__c = stateTax;
        
        payment.sigmaerpdev2__ReceiptNumber__c = receiptNumber;
        // new code to add the amount paying for card  
        var amount=component.get("v.TotalOrderAmount");
        //alert('amount::'+amount);
        if(amount<0)
        {
             var msg = "Complete payment is done for this Order.";
             component.set("v.errorMsg", msg);
             component.set("v.isError",true);
             return;
            
        }
        payment.sigmaerpdev2__Amount__c = component.get("v.TotalOrderAmount");
        payment.sigmaerpdev2__Due_Amount__c = component.get("v.TotalOrderAmount");
        if(component.get("v.SigmaOrder")==true)
        {
        component.set("v.receivedFrom",order[0].sigmaerpdev2__AccountId__r.Name);
            payment.sigmaerpdev2__Customer_SFID__c = order[0].sigmaerpdev2__AccountId__c;
            payment.sigmaerpdev2__SFDC_Account__c = order[0].sigmaerpdev2__AccountId__c; 
        }
        else if(component.get("v.StndOrder")==true)
        {
            component.set("v.receivedFrom",order[0].Account.Name);
            payment.sigmaerpdev2__Customer_SFID__c = order[0].AccountId;
            payment.sigmaerpdev2__SFDC_Account__c = order[0].AccountId;
        }
            //alert('payment due ammount::'+payment.sigmaerpdev2__Due_Amount__c);
    },
    checkForCardType : function(component, event, helper)
    {
        var accountNumber = component.get("v.paymentObj.sigmaerpdev2__Credit_CardNumber__c");
        accountNumber = accountNumber.replace(/ +/g, ""); //added to remove empty spaces b/w numbers if its pasted instead of typing
       var result = "Enter card number";
        
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
       
    },
     save : function(component, event, helper) 
    {	 
        
        var cashAmt = component.find("cashReceived").get('v.value');
		//alert('cashAmt'+cashAmt);
        var validationOfAmount = component.find("cashReceived");
        var cashReceived  = parseFloat(cashAmt);
        component.set("v.ReceivedAmt",cashReceived);
         if(cashReceived < component.get("v.TotalOrderAmount"))
        {
             validationOfAmount.set("v.errors", [{message:"Entered Amount is Less than Total Bill Amount."}]);
            return null;
        }
        else
        {
            if(component.get("v.SigmaOrder")==true)
            {
                // alert('call');
                helper.saveCardPayments(component,event); 
            }
            else if(component.get("v.StndOrder")==true)
            {
                //alert('callelse');
                helper.savestdCardPayments(component,event);  
            }
            
        }
        
    },
    gotoPaymentOptions : function(component, event, helper) 
    { 
        var custName = component.get("v.receivedFrom");
        var totalAmount = component.get("v.billAmount");
       
        var cashFlag = component.get("v.cashPaymentFlag");
        var taxEvent = component.getEvent("taxEventValues");  
        
        // Populate the event with the selected Object Id and Instance Id
        taxEvent.setParams({
            "customerName" : custName, 
            "totalAmount" : totalAmount  
        });

        // Fire the event
        taxEvent.fire();
                
 	},
     cancelpayment : function(component, event, helper){
      window.history.back();    
    }
})
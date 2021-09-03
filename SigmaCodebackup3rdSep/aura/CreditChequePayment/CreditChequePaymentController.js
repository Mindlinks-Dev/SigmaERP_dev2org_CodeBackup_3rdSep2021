({
    doInitForCheque : function(component, event, helper) 
    {
       
    	var receiptNumber = " ";
    	var charset = "abcdefghijklmnopqrstuvwxyz0123456789";
    	for(var i=0; i < 6; i++)
        {
    		receiptNumber += charset.charAt(Math.floor(Math.random() * charset.length));
    	}      
        
        component.set('v.chequeReceiptNo', receiptNumber);
        
        var payment = component.get("v.paymentObj");
        payment.sObjectType = 'sigmaerpdev__Payment__c';
         var amount=component.get("v.billAmount");
        //alert('amount::'+amount);
        if(amount<0)
        {
             var msg = "Complete payment is done for this Order.";
             component.set("v.errorMsg", msg);
             component.set("v.isError",true);
             return;
            
        }
       // payment.sigmaerpdev__Amount__c = component.get("v.billAmount");
       
        payment.sigmaerpdev__Due_Amount__c = component.get("v.billAmount");
        
        var billAmount = component.get("v.billAmount");        
        payment.sigmaerpdev__Amount__c = billAmount; 
        var receivedFrom = component.get("v.receivedFrom");
        payment.sigmaerpdev__Customer_Name__c = receivedFrom;
        var chequeReceiptNo = component.get('v.chequeReceiptNo');
        payment.sigmaerpdev__ReceiptNumber__c = chequeReceiptNo;  
        var accountSFId = component.get('v.recordId');
        payment.sigmaerpdev__SFDC_Account__c = accountSFId; 
        var order_SFId = component.get('v.orderSFId');
       
         var cashsub = component.get("v.subpayment");
        if(cashsub==true)
        {
        payment.sigmaerpdev__Account_Subscription_Interval__c = order_SFId;
        }else
        {
            payment.sigmaerpdev__Sigma_Order__c = order_SFId;
        }
        var totalTaxAmount = component.get('v.totalTaxAmount');
        payment.sigmaerpdev__Tax_Amount__c = totalTaxAmount;
        
        payment.sigmaerpdev__Order_Type__c = 'Offline';
        payment.sigmaerpdev__Order_Created_Via__c = 'POS';
        payment.sigmaerpdev__Payment_Mode__c = 'Cheque'; 
        
        var fedTax = component.get('v.FederalTax');
        var stateTax = component.get('v.StateTax');        
        payment.sigmaerpdev__Federal_Tax__c = fedTax; 
        payment.sigmaerpdev__State_Tax__c = stateTax; 
        
        var currentdate = new Date();
        currentdate = currentdate.toString().replace(/UTC\s/,"");
        currentdate = currentdate.replace(/GMT.+/,"");                
        currentdate = currentdate.substring(4, 15);        
        component.set('v.paymentDate', currentdate);
             
    },
    
    
    
	gotoPaymentOptions : function(component, event, helper) 
    {
        	var custName = component.get("v.receivedFrom");
            var totalAmount = component.get("v.billAmount");
            
            var cashFlag = component.get("v.cashPaymentFlag");
           
            var taxEvent = component.getEvent("taxEventValues");  
            
             taxEvent.setParams({
            "customerName" : custName, 
            "totalAmount" : totalAmount  
        });

        // Fire the event
        taxEvent.fire();
        
        
    
 },
    
     save : function(component, event, helper) {
         var cashAmt = component.find("cashReceived").get('v.value');
		//alert('cashAmt'+cashAmt);
        var validationOfAmount = component.find("cashReceived");
        var cashReceived  = parseFloat(cashAmt);
        component.set("v.ReceivedAmt",cashReceived);
       
        if(isNaN(cashReceived)){
            validationOfAmount.set("v.errors", [{message:"Please Enter a cash to be received."}]);
            return null;
        }
        else if(cashReceived<=0)
        {
             validationOfAmount.set("v.errors", [{message:"Entered Amount is Less than Total Bill Amount."}]);
            return null;
        }
        else{
            validationOfAmount.set("v.errors",null);
        }
         
         
	     var spinner = component.find('spinner');
		$A.util.addClass(spinner, "slds-show");   
  		helper.saveChequePayments(component,event);
     

 },
   
})
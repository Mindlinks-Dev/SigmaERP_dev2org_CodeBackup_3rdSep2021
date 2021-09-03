({
    
    doInitForCash : function(component, event, helper) 
    {
        var payment = component.get("v.paymentObj");
        payment.sobjectType = 'sigmaerpdev__Payment__c';                
        var amount=component.get("v.billAmount");
        //alert('amount::'+amount);
        if(amount<0)
        {
             var msg = "Complete payment is done for this Order.";
             component.set("v.errorMsg", msg);
             component.set("v.isError",true);
             return;
            
        }
        payment.sigmaerpdev__Amount__c = component.get("v.billAmount");
        payment.sigmaerpdev__Due_Amount__c = component.get("v.billAmount");
        payment.sigmaerpdev__Customer_Name__c = component.get("v.receivedFrom");
       // alert('customer'+payment.sigmaerpdev__Customer_Name__c);
       // alert('dueamount'+payment.sigmaerpdev__Due_Amount__c);
       // alert('Amount'+payment.sigmaerpdev__Amount__c);
        var accountSFId = component.get('v.recordId');
        alert('Account'+accountSFId);
        payment.sigmaerpdev__SFDC_Account__c = accountSFId; 
       // var order_SFId = component.get('v.orderSFId');
      // alert('length'+component.get('v.orderSFId').length);
       // alert('Order'+component.get('v.orderSFId'));
        var order_SFId=[];
        order_SFId.push(component.get('v.orderSFId')); 
      //  alert('order_SFId'+order_SFId);
        var cashsub = component.get("v.subpayment");
        if(cashsub==true)
        {
        payment.sigmaerpdev__Account_Subscription_Interval__c = order_SFId;
        }else
        {
           // alert('IINNN');
            for(i=0;i<order_SFId.length;i++)
            payment.sigmaerpdev__Sigma_Order__c = order_SFId[i];
        }
        alert('IDDDDD'+payment.sigmaerpdev__Sigma_Order__c);
       
        var totalTaxAmount = component.get('v.totalTaxAmount');
       // alert('total:::'+totalTaxAmount);
        payment.sigmaerpdev__Tax_Amount__c = totalTaxAmount;
       // alert('tax::'+payment.sigmaerpdev__Tax_Amount__c);
        payment.sigmaerpdev__Order_Type__c = 'Offline';
        payment.sigmaerpdev__Order_Created_Via__c = 'POS';
        payment.sigmaerpdev__Payment_Mode__c = 'Cash'; 
        
        var fedTax = component.get('v.FederalTax');
        var stateTax = component.get('v.StateTax');
        
        payment.sigmaerpdev__Federal_Tax__c = fedTax; 
        payment.sigmaerpdev__State_Tax__c = stateTax; 
        
    	var receiptNumber = " ";
    	var charset = "abcdefghijklmnopqrstuvwxyz0123456789";
    	for(var i=0; i < 6; i++)
        {
    		receiptNumber += charset.charAt(Math.floor(Math.random() * charset.length));
    	}      
        
        payment.sigmaerpdev__ReceiptNumber__c = receiptNumber;
       
        var currentdate = new Date();
        currentdate = currentdate.toString().replace(/UTC\s/,"");
        currentdate = currentdate.replace(/GMT.+/,"");                
        currentdate = currentdate.substring(4, 15);        
        component.set('v.paymentDate', currentdate);
       
    },   
    
        
	gotoPaymentOptions : function(component, event, helper) 
    { 
        var custName = component.get("v.receivedFrom");
        alert('cus'+custName);
        var totalAmount = component.get("v.billAmount");
        alert('totalAmount:::'+totalAmount);
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
   
    
    save : function(component, event, helper) 
    {	                       
        var cashAmt = component.find("cashReceived").get('v.value');
		alert('cashAmt'+cashAmt);
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
		//alert('validationOfAmount ofter set::'+validationOfAmount);
        var spinner = component.find('spinner');
		$A.util.addClass(spinner, "slds-show");  
        var cashReceiptNo = component.get("v.cashReceiptNo");
       	var receivedFrom = component.get("v.receivedFrom");
       	var billAmount = component.get("v.billAmount");
        
        //alert('receivedFrom3::'+JSON.stringify(component.get("v.billAmount")));
  		helper.saveCashPayments(component,event); 
        
       
 },
    
     computeBalanceDue : function(cmp,event,helper)
    {
        var TotalBillAmount = (parseFloat(cmp.find('total_BillAmount').get('v.value'))).toFixed(2);
      
        var cashAmt = cmp.find("cashReceived").get('v.value');
        var cashReceived  = parseFloat(cashAmt);
       if(cashReceived > 0)
         {
             var balanceDue = cashReceived - TotalBillAmount;
           
             cmp.set('v.BalAmount',balanceDue.toFixed(2));
         }
        
       
    }
})
({
    
    doInitForCash : function(component, event, helper) 
    {
  
       
        var payment = component.get("v.paymentObj");
        payment.sobjectType = 'sigmaerpdev2__Payment__c';                
        var amount=component.get("v.billAmount");
        // alert('amount::'+amount);
        if(amount<0)
        {
            var msg = "Complete payment is done for this Order.";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;
            
        }
        payment.sigmaerpdev2__Amount__c = component.get("v.billAmount");
        payment.sigmaerpdev2__Due_Amount__c = component.get("v.billAmount");
        
        //payment.sigmaerpdev2__Amount__c = component.get("v.billAmount");
        payment.sigmaerpdev2__Customer_Name__c = component.get("v.receivedFrom");
        var accountSFId = component.get('v.recordId');
        payment.sigmaerpdev2__SFDC_Account__c = accountSFId; 
        var order_SFId = component.get('v.orderSFId');
        var cashsub = component.get("v.subpayment");
        if(cashsub==true)
        {
            payment.sigmaerpdev2__Account_Subscription_Interval__c = order_SFId;
        }else
        {
            payment.sigmaerpdev2__OrderId__c = order_SFId;
            
        }
        
        
        
        var totalTaxAmount = component.get('v.totalTaxAmount');
        payment.sigmaerpdev2__Tax_Amount__c = totalTaxAmount;
        
        payment.sigmaerpdev2__Order_Type__c = 'Offline';
        payment.sigmaerpdev2__Order_Created_Via__c = 'POS';
        payment.sigmaerpdev2__Payment_Mode__c = 'Cash'; 
        
        var fedTax = component.get('v.FederalTax');
        var stateTax = component.get('v.StateTax');
        
        payment.sigmaerpdev2__Federal_Tax__c = fedTax; 
        payment.sigmaerpdev2__State_Tax__c = stateTax; 
        
        var receiptNumber = " ";
        var charset = "abcdefghijklmnopqrstuvwxyz0123456789";
        for(var i=0; i < 6; i++)
        {
            receiptNumber += charset.charAt(Math.floor(Math.random() * charset.length));
        }      
        
        payment.sigmaerpdev2__ReceiptNumber__c = receiptNumber;
        
        var currentdate = new Date();
        currentdate = currentdate.toString().replace(/UTC\s/,"");
        currentdate = currentdate.replace(/GMT.+/,"");                
        currentdate = currentdate.substring(4, 15);        
        component.set('v.paymentDate', currentdate);
        
       // component.set("v.Spinner", false);
        
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
    
    
    save : function(component, event, helper) 
    {	                       
        var cashAmt = component.find("cashReceived").get('v.value');
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
        var cashReceiptNo = component.get("v.cashReceiptNo");
        var receivedFrom = component.get("v.receivedFrom");
        
        var billAmount = component.get("v.billAmount");
        helper.saveCashPayments(component,event); 
        
        
    },
    
    computeBalanceDue : function(cmp,event,helper)
    {
        var TotalBillAmount = (parseFloat(cmp.find('total_BillAmount').get('v.value'))).toFixed(2);
        
        var cashAmt = cmp.find("cashReceived").get('v.value');
        var cashReceived  = parseFloat(cashAmt);
        if(cashReceived > 0)
        {
            var balanceDue = TotalBillAmount-cashReceived;
            
            cmp.set('v.BalAmount',balanceDue.toFixed(2));
        }
        else
        {
            var balanceDue = TotalBillAmount;
            
            cmp.set('v.BalAmount',balanceDue);
        }
        
        
    }
})
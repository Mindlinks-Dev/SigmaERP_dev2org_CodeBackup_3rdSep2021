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
		var order = component.get('v.selectedOrderList')
        
        var payment = component.get("v.paymentObj");
        payment.sObjectType = 'sigmaerpdev2__Payment__c';
         var amount=component.get("v.TotalOrderAmount");
       // alert('amount::'+amount);
       
       
        payment.sigmaerpdev2__Due_Amount__c = component.get("v.TotalOrderAmount");
        
        var billAmount = component.get("v.TotalOrderAmount");        
        payment.sigmaerpdev2__Amount__c = billAmount; 
        if(component.get("v.SigmaOrder")==true)
        {
        	payment.sigmaerpdev2__Customer_Name__c = order[0].sigmaerpdev2__AccountId__r.Name;
            payment.sigmaerpdev2__Customer_SFID__c = order[0].sigmaerpdev2__AccountId__c;
            payment.sigmaerpdev2__SFDC_Account__c = order[0].sigmaerpdev2__AccountId__c; 
        }
        else if(component.get("v.StndOrder")==true)
        {
            payment.sigmaerpdev2__Customer_Name__c = order[0].Account.Name
        	payment.sigmaerpdev2__Customer_SFID__c = order[0].AccountId;
            payment.sigmaerpdev2__SFDC_Account__c = order[0].AccountId; 
        }
        var chequeReceiptNo = component.get('v.chequeReceiptNo');
        payment.sigmaerpdev2__ReceiptNumber__c = chequeReceiptNo;  
        //var totalTaxAmount = component.get('v.totalTaxAmount');
        //payment.sigmaerpdev2__Tax_Amount__c = totalTaxAmount;
        
        payment.sigmaerpdev2__Order_Type__c = 'Offline';
        payment.sigmaerpdev2__Order_Created_Via__c = 'POS';
        payment.sigmaerpdev2__Payment_Mode__c = 'Cheque'; 
        
         var totalTaxAmount = component.get('v.totalTaxAmount');
        payment.sigmaerpdev2__Tax_Amount__c = totalTaxAmount;
        var fedTax = component.get('v.FederalTax');
        var stateTax = component.get('v.StateTax');
        
        payment.sigmaerpdev2__Federal_Tax__c = fedTax; 
        payment.sigmaerpdev2__State_Tax__c = stateTax;
        //var fedTax = component.get('v.FederalTax');
        //var stateTax = component.get('v.StateTax');        
        //payment.sigmaerpdev2__Federal_Tax__c = fedTax; 
        //payment.sigmaerpdev2__State_Tax__c = stateTax; 
        
        var currentdate = new Date();
        currentdate = currentdate.toString().replace(/UTC\s/,"");
        currentdate = currentdate.replace(/GMT.+/,"");                
        currentdate = currentdate.substring(4, 15);        
        component.set('v.paymentDate', currentdate);
      //  alert(component.get('v.paymentDate'));     
    },
     save : function(component, event, helper) {
             var cashAmt = component.find("cashReceived").get('v.value');
             var validationOfAmount = component.find("cashReceived");
             var cashReceived  = parseFloat(cashAmt);
             component.set("v.ReceivedAmt",cashReceived);
             var spinner = component.find('spinner');
             $A.util.addClass(spinner, "slds-show");   
         if(cashReceived<component.get("v.paymentObj.sigmaerpdev2__Amount__c"))
        {
             validationOfAmount.set("v.errors", [{message:"Entered Amount is Less than Total Bill Amount."}]);
            return null;
        }
         else
         {
             if(component.get("v.SigmaOrder")==true)
             {
                 helper.saveChequePayments(component,event); 
             }
             else if(component.get("v.StndOrder")==true)
             {
                 helper.savestdChequePayments(component,event);  
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
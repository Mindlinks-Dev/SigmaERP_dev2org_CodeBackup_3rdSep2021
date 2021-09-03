({
    
    doInitForCash : function(component, event, helper) 
    {
        
        var payment = component.get("v.paymentObj");
		var order = component.get('v.selectedOrderList');
         payment.sobjectType = 'sigmaerpdev2__Payment__c';                
        var amount=component.get("v.TotalOrderAmount");
        payment.sigmaerpdev2__Amount__c = component.get("v.TotalOrderAmount");
        payment.sigmaerpdev2__Due_Amount__c = component.get("v.TotalOrderAmount");
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
        var totalTaxAmount = component.get('v.totalTaxAmount');
        payment.sigmaerpdev2__Tax_Amount__c = totalTaxAmount;
        
		var fedTax = component.get('v.FederalTax');
        var stateTax = component.get('v.StateTax');
        
        payment.sigmaerpdev2__Federal_Tax__c = fedTax; 
        payment.sigmaerpdev2__State_Tax__c = stateTax; 
       
        payment.sigmaerpdev2__Order_Type__c = 'Offline';
        payment.sigmaerpdev2__Order_Created_Via__c = 'POS';
        payment.sigmaerpdev2__Payment_Mode__c = 'Cash'; 
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
        
       
    },
    computeBalanceDue : function(cmp,event,helper)
    {
        var TotalBillAmount = (parseFloat(cmp.find('total_BillAmount').get('v.value'))).toFixed(2);
      
        var cashAmt = cmp.find("cashReceived").get('v.value');
        var cashReceived  = parseFloat(cashAmt);
       
       if(cashReceived > 0)
         {
             
             var balanceDue = TotalBillAmount-cashReceived ;
           
             cmp.set('v.BalAmount',balanceDue.toFixed(2));
         }
        else
         {
            var balanceDue = TotalBillAmount;
           cmp.set('v.BalAmount',balanceDue);
         }
        
       
    },
    save : function(component, event, helper) 
    {	                       
        var cashAmt = component.find("cashReceived").get('v.value');
        
		var validationOfAmount = component.find("cashReceived");
        var cashReceived  = parseFloat(cashAmt);
        component.set("v.ReceivedAmt",cashReceived);
        var spinner = component.find('spinner');
		$A.util.addClass(spinner, "slds-show"); 
         if(cashReceived<component.get("v.TotalOrderAmount"))
        {
             validationOfAmount.set("v.errors", [{message:"Entered Amount is Less than Total Bill Amount."}]);
            return null;
        }
        else
        {
         	if(component.get("v.SigmaOrder")==true)
            {
                helper.saveCashPayments(component,event);     
            }
            else if(component.get("v.StndOrder")==true)
            {
                helper.savestdCashPayments(component,event);  
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
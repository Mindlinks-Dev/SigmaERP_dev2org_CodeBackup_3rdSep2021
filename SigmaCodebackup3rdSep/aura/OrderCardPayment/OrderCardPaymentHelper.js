({
	saveCardPayments : function(component, event)
    {
        var cardValidationResult = this.checkCreditCard(component,event);
       if(cardValidationResult)
		{
			this.makeChargeAfterValidation(component, event);
		}
		else
		{
			alert("Invalid Card Details");
		}
        
    },
	makeChargeAfterValidation : function(component,event)
	{
        var spinner = component.find('spinner');
        $A.util.addClass(spinner, "slds-show");  
        var creditCardID = component.find('Credit_card_number');
        
        var creditCardNumber = creditCardID.get('v.value');
		creditCardNumber = creditCardNumber.replace(/ +/g, ""); //added to remove empty spaces b/w numbers if its pasted instead of typing
        var creditCardLength = 16;
        var mystring = creditCardNumber.substring(0, 2);
        if(mystring == '34' || mystring == '37')
            creditCardLength = 15;
       
		var creditCardType = component.get("v.selectedCardType");
		
        if(creditCardNumber.length < creditCardLength || isNaN(creditCardNumber) || creditCardNumber == null)
        {
            creditCardID.set("v.errors", [{message:"Enter valid "+creditCardLength+" digit credit card number."}]);
            var spinners = component.find('spinner');
            $A.util.removeClass(spinners, 'slds-show');	
            return null;
        }else
        {
            creditCardID.set("v.errors", null);
        }
        
        var expiryID = component.find('Expiry_Date');
        var expiryDate = expiryID.get('v.value');
        
        var currentdate = new Date();                	
        currentdate.setDate(currentdate.getDate() - 1);
        var expdate = new Date(expiryDate);
        if(expiryDate== '' || expiryDate == null)
        {
            expiryID.set("v.errors", [{message:"Enter Expiry date."}]);
            var spinners = component.find('spinner');
            $A.util.removeClass(spinners, 'slds-show');	
            return null;
            
        }else
        {
            expiryID.set("v.errors", null);
        }
        
        if(expdate <= currentdate)
        {
            expiryID.set("v.errors", [{message:"Card expiry date must be greater than today's date."}]);
            var spinners = component.find('spinner');
            $A.util.removeClass(spinners, 'slds-show');	
            return null;
        }
        else
        {
            expiryID.set("v.errors", null);            
        }
        
        var zipCode = component.find('Zip_code').get('v.value');
        
        var cardVerificationValue = component.find('cardVerificationValue');
        var CVV = component.find('cardVerificationValue').get('v.value');       
         if(isNaN(CVV) || CVV == null || CVV == undefined)
        {
            cardVerificationValue.set("v.errors", [{message:"Enter valid CVV Number "}]);
            var spinners = component.find('spinner');
            $A.util.removeClass(spinners, 'slds-show');		
            return null;
        }
        else if(CVV.length < 3)
        {             
            cardVerificationValue.set("v.errors", [{message:"CVV Number should be of 3 digits "}]);
            var spinners = component.find('spinner');
            $A.util.removeClass(spinners, 'slds-show');	
            return null;
        }
            else
            {
                cardVerificationValue.set("v.errors", null);   
            }
        
        
        var cardHolderName =  component.find('Card_holderName').get('v.value');
        var receivedFrom = component.get("v.receivedFrom");
        //var accountSFId = component.get('v.recordId');
        var paymentMode = 'Card';	
        //var orderSFId = component.get('v.orderSFId');
        //alert('orderSFId>>>>>>>'+orderSFId);
        var chargeAmount = component.get('v.amountTobeCharged'); 
        var paidAmount = component.get('v.paidAmount');
        //alert('orderSFId>>>>>>>'+component.set('v.paidAmount'));
        //var totalTaxAmount = component.get('v.totalTaxAmount');
        //var fedTax = component.get('v.FederalTax');
        //var stateTax = component.get('v.StateTax'); 
        var expiryArray = expiryDate.split('-');
        var expiryMonth = expiryArray[1];
        var expiryYear = expiryArray[0];
        var vendorType;
        
        doPayPalPayment(); 
        
        function doPayPalPayment()
        {
              
            var receviedamt = component.get("v.ReceivedAmt");     
        	//alert('after set'+receviedamt);
            var payment = component.get("v.paymentObj");
            var accountId = component.get("v.selectedOrderList[0].sigmaerpdev2__AccountId__c");
			//alert('accountId@@'+accountId);
            payment.sobjectType= 'sigmaerpdev2__Payment__c';
            
            
            payment.sigmaerpdev2__Amount__c = chargeAmount;
            payment.sigmaerpdev2__Payment_Mode__c = 'Card'; 
           // payment.sigmaerpdev2__Customer_SFID__c = accountSFId;
            payment.sigmaerpdev2__Customer_Name__c = receivedFrom;
            payment.sigmaerpdev2__Order_Type__c = 'Offline';
            payment.sigmaerpdev2__Order_Created_Via__c = 'POS';
            payment.sigmaerpdev2__Paid_Amount__c = paidAmount;
            //payment.sigmaerpdev2__Federal_Tax__c = fedTax; 
            //payment.sigmaerpdev2__State_Tax__c = stateTax;             
            //payment.sigmaerpdev2__Tax_Amount__c = totalTaxAmount;
            payment.sigmaerpdev2__Amount_Recevied__c = receviedamt;
			payment.sigmaerpdev2__Card_Type__c = component.get("v.selectedCardType");
           //alert('cardsub'+paidAmount);
           var order = component.get("v.selectedOrderList");    
       	  // component.set("v.SigmaOrder",order);
            
              //alert('else of payment'); 
               var actionPaypal = component.get("c.stripePayment"); 
            actionPaypal.setParams
            ({
                "payment"  : payment,
                "chargeAmount" : receviedamt,
                "CVV"      : CVV,
                "expiryMonth" : expiryMonth,
                "expiryYear"  : expiryYear,
                "zipCode"     : zipCode,
                "paidAmount"  : paidAmount,
                "accountid" : accountId,
                "order":order
            });  
            actionPaypal.setCallback(this, function(response) 
                                     {
                                         var state = response.getState();
                                        // alert('state'+state);
                                         // alert('response.getReturnValue'+response.getReturnValue());
                                         if (component.isValid() && state == "SUCCESS")
                                         {               
                                             var returnValues = response.getReturnValue();                
                                            if ( returnValues == null || returnValues == '')
                                             {    
                                                 alert('Payment Failed.');
                                                 return;
                                             }
                                             alert('Payment done successfully.');
                                              document.getElementById("Accspinner").style.display = "none";
                                             //window.location.href = "/" + accountId;
                                          var transSuccessEvent = component.getEvent("transSuccessEvent");   
                							transSuccessEvent.fire();
                                         
                                         }
                                         else if (state == "ERROR") 
                                         {
                                             var errors = response.getError();
                                             if (errors) 
                                             {
                                                 if (errors[0] && errors[0].message) 
                                                 {
                                                     alert("Error message: " + 
                                                           errors[0].message);
                                                 }
                                             }
                                             else 
                                             {
                                                 console.log("Unknown error");
                                             }
                                         }
                                     }); 
            
            
            $A.enqueueAction(actionPaypal); 
            
        }
        var token = '';
        var action = '';//previous
        //action = '';
		document.getElementById("Accspinner").style.display = "block";
	},

    checkCreditCard : function(component,event)
    {
        
        var ccErrorNo = 0;
        var ccErrors = new Array ();//Previous
        var cardname = component.get("v.selectedCardType");
       var creditCardID = component.find('Credit_card_number');
        var cardnumber = creditCardID.get('v.value');
        
        
        ccErrors [0] = "Unknown card type";
        ccErrors [1] = "No card number provided";
        ccErrors [2] = "Credit card number is in invalid format";
        ccErrors [3] = "Credit card number is invalid";
        ccErrors [4] = "Credit card number has an inappropriate number of digits";
        ccErrors [5] = "Warning! This credit card number is associated with a scam attempt";
        var cards = new Array();//previous line 
       
        cards [0] = {name: "Visa", 
                     length: "13,16", 
                     prefixes: "4",
                     checkdigit: true};
        cards [1] = {name: "MasterCard", 
                     length: "16", 
                     prefixes: "51,52,53,54,55",
                     checkdigit: true};
        cards [2] = {name: "AmEx", 
                     length: "15", 
                     prefixes: "34,37",
                     checkdigit: true};
        
       var cardType = -1;
        for (var i=0; i<cards.length; i++) {
            
           if (cardname.toLowerCase () == cards[i].name.toLowerCase()) 
            {                
                cardType = i;
                break;
            }
        }
        
        // If card type not found, report an error
        if (cardType == -1) {
            ccErrorNo = 0;
            return false; 
        }
        
        // Ensure that the user has provided a credit card number
        if (cardnumber.length == 0)  {
            ccErrorNo = 1;
            return false; 
        }
        
        // Now remove any spaces from the credit card number
        cardnumber = cardnumber.replace (/\s/g, "");
        
        // Check that the number is numeric
        var cardNo = cardnumber
        var cardexp = /^[0-9]{13,19}$/;
        if (!cardexp.exec(cardNo))  {
            ccErrorNo = 2;
            return false; 
        }
        // Now check the modulus 10 check digit - if required
        if (cards[cardType].checkdigit) {
            var checksum = 0;                                  // running checksum total
            var mychar = "";                                   // next char to process
            var j = 1;                                         // takes value of 1 or 2
            
            // Process each digit one by one starting at the right
            var calc;
            for (i = cardNo.length - 1; i >= 0; i--) {
                
                // Extract the next digit and multiply by 1 or 2 on alternative digits.
                calc = Number(cardNo.charAt(i)) * j;
                
                // If the result is in two digits add 1 to the checksum total
                if (calc > 9) {
                    checksum = checksum + 1;
                    calc = calc - 10;
                }
                
                // Add the units element to the checksum total
                checksum = checksum + calc;
                
                // Switch the value of j
                if (j ==1) {j = 2} else {j = 1};
            } 
            
            // All done - if checksum is divisible by 10, it is a valid modulus 10.
            // If not, report an error.
            if (checksum % 10 !== 0)  {
                ccErrorNo = 3;
                return false; 
            }
        }  
       // Check it's not a spam number
        if (cardNo == '5490997771092064') { 
            ccErrorNo = 5;
            return false; 
        }
        // The following are the card-specific checks we undertake.
        var LengthValid = false;
        var PrefixValid = false; 
        var undefined; 
        
        // We use these for holding the valid lengths and prefixes of a card type
        var prefix = new Array ();
        var lengths = new Array ();
         prefix = cards[cardType].prefixes.split(",");
        
        // Now see if any of them match what we have in the card number
        for (i=0; i<prefix.length; i++) {
            var exp = new RegExp ("^" + prefix[i]);
            if (exp.test (cardNo)) PrefixValid = true;
        }
        
        // If it isn't a valid prefix there's no point at looking at the length
        if (!PrefixValid) {
            ccErrorNo = 3;
            return false; 
        }
        // See if the length is valid for this card
        lengths = cards[cardType].length.split(",");
        for (j=0; j<lengths.length; j++) {
            if (cardNo.length == lengths[j]) LengthValid = true;
        }
        
        // See if all is OK by seeing if the length was valid. We only check the length if all else was 
        // hunky dory.
        if (!LengthValid) {
            ccErrorNo = 4;
            return false; 
        };   
       // The credit card is in the required format.
        return true;
    },
    savestdCardPayments : function(component, event)
    {
        var cardValidationResult = this.checkCreditCard(component,event);
       if(cardValidationResult)
		{
			this.makeChargeAfterValidation1(component, event);
		}
		else
		{
			alert("Invalid Card Details");
		}
        
    },
	makeChargeAfterValidation1 : function(component,event)
	{
        var spinner = component.find('spinner');
        $A.util.addClass(spinner, "slds-show");  
        var creditCardID = component.find('Credit_card_number');
        
        var creditCardNumber = creditCardID.get('v.value');
		creditCardNumber = creditCardNumber.replace(/ +/g, ""); //added to remove empty spaces b/w numbers if its pasted instead of typing
        var creditCardLength = 16;
        var mystring = creditCardNumber.substring(0, 2);
        if(mystring == '34' || mystring == '37')
            creditCardLength = 15;
       
		var creditCardType = component.get("v.selectedCardType");
		
        if(creditCardNumber.length < creditCardLength || isNaN(creditCardNumber) || creditCardNumber == null)
        {
            creditCardID.set("v.errors", [{message:"Enter valid "+creditCardLength+" digit credit card number."}]);
            var spinners = component.find('spinner');
            $A.util.removeClass(spinners, 'slds-show');	
            return null;
        }else
        {
            creditCardID.set("v.errors", null);
        }
        
        var expiryID = component.find('Expiry_Date');
        var expiryDate = expiryID.get('v.value');
        
        var currentdate = new Date();                	
        currentdate.setDate(currentdate.getDate() - 1);
        var expdate = new Date(expiryDate);
        if(expiryDate== '' || expiryDate == null)
        {
            expiryID.set("v.errors", [{message:"Enter Expiry date."}]);
            var spinners = component.find('spinner');
            $A.util.removeClass(spinners, 'slds-show');	
            return null;
            
        }else
        {
            expiryID.set("v.errors", null);
        }
        
        if(expdate <= currentdate)
        {
            expiryID.set("v.errors", [{message:"Card expiry date must be greater than today's date."}]);
            var spinners = component.find('spinner');
            $A.util.removeClass(spinners, 'slds-show');	
            return null;
        }
        else
        {
            expiryID.set("v.errors", null);            
        }
        
        var zipCode = component.find('Zip_code').get('v.value');
        
        var cardVerificationValue = component.find('cardVerificationValue');
        var CVV = component.find('cardVerificationValue').get('v.value');       
         if(isNaN(CVV) || CVV == null || CVV == undefined)
        {
            cardVerificationValue.set("v.errors", [{message:"Enter valid CVV Number "}]);
            var spinners = component.find('spinner');
            $A.util.removeClass(spinners, 'slds-show');		
            return null;
        }
        else if(CVV.length < 3)
        {             
            cardVerificationValue.set("v.errors", [{message:"CVV Number should be of 3 digits "}]);
            var spinners = component.find('spinner');
            $A.util.removeClass(spinners, 'slds-show');	
            return null;
        }
            else
            {
                cardVerificationValue.set("v.errors", null);   
            }
        
        
        var cardHolderName =  component.find('Card_holderName').get('v.value');
        var receivedFrom = component.get("v.receivedFrom");
        //var accountSFId = component.get('v.recordId');
        var paymentMode = 'Card';	
        //var orderSFId = component.get('v.orderSFId');
        //alert('orderSFId>>>>>>>'+orderSFId);
        var chargeAmount = component.get('v.amountTobeCharged'); 
        var paidAmount = component.get('v.paidAmount');
        //alert('orderSFId>>>>>>>'+component.set('v.paidAmount'));
        //var totalTaxAmount = component.get('v.totalTaxAmount');
        //var fedTax = component.get('v.FederalTax');
        //var stateTax = component.get('v.StateTax'); 
        var expiryArray = expiryDate.split('-');
        var expiryMonth = expiryArray[1];
        var expiryYear = expiryArray[0];
        var vendorType;
        
        doPayPalPayment(); 
        
        function doPayPalPayment()
        {
              
            var receviedamt = component.get("v.ReceivedAmt");     
        	//alert('after set'+receviedamt);
            var payment = component.get("v.paymentObj");
            var accountId = component.get("v.selectedOrderList[0].AccountId");
			
            payment.sobjectType= 'sigmaerpdev2__Payment__c';
            
            
            payment.sigmaerpdev2__Amount__c = chargeAmount;
            payment.sigmaerpdev2__Payment_Mode__c = 'Card'; 
           // payment.sigmaerpdev2__Customer_SFID__c = accountSFId;
            payment.sigmaerpdev2__Customer_Name__c = receivedFrom;
            payment.sigmaerpdev2__Order_Type__c = 'Offline';
            payment.sigmaerpdev2__Order_Created_Via__c = 'POS';
            payment.sigmaerpdev2__Paid_Amount__c = paidAmount;
            //payment.sigmaerpdev2__Federal_Tax__c = fedTax; 
            //payment.sigmaerpdev2__State_Tax__c = stateTax;             
            //payment.sigmaerpdev2__Tax_Amount__c = totalTaxAmount;
            payment.sigmaerpdev2__Amount_Recevied__c = receviedamt;
			payment.sigmaerpdev2__Card_Type__c = component.get("v.selectedCardType");
           //alert('cardsub'+paidAmount);
           var order = component.get("v.selectedOrderList");    
       	  // component.set("v.SigmaOrder",order);
            
              //alert('else of payment'); 
               var actionPaypal = component.get("c.stdstripePayment"); 
            actionPaypal.setParams
            ({
                "payment"  : payment,
                "chargeAmount" : receviedamt,
                "CVV"      : CVV,
                "expiryMonth" : expiryMonth,
                "expiryYear"  : expiryYear,
                "zipCode"     : zipCode,
                "paidAmount"  : paidAmount,
                "accountid" : accountId,
                "order":order
            });  
            actionPaypal.setCallback(this, function(response) 
                                     {
                                         var state = response.getState();
                                        // alert('state'+state);
                                         // alert('response.getReturnValue'+response.getReturnValue());
                                         if (component.isValid() && state == "SUCCESS")
                                         {               
                                             var returnValues = response.getReturnValue();                
                                            if ( returnValues == null || returnValues == '')
                                             {    
                                                 alert('Payment Failed.');
                                                 return;
                                             }
                                             alert('Payment done successfully.');
                                              document.getElementById("Accspinner").style.display = "none";
                                       //  window.location.href = "/" + accountId;
                                          var transSuccessEvent = component.getEvent("transSuccessEvent");   
                						  transSuccessEvent.fire();
                                         
                                         }
                                         else if (state == "ERROR") 
                                         {
                                             var errors = response.getError();
                                             if (errors) 
                                             {
                                                 if (errors[0] && errors[0].message) 
                                                 {
                                                     alert("Error message: " + 
                                                           errors[0].message);
                                                 }
                                             }
                                             else 
                                             {
                                                 console.log("Unknown error");
                                             }
                                         }
                                     }); 
            
            
            $A.enqueueAction(actionPaypal); 
            
        }
        var token = '';
        var action = '';//previous
        //action = '';
		document.getElementById("Accspinner").style.display = "block";
	},

    checkCreditCard : function(component,event)
    {
        
        var ccErrorNo = 0;
        var ccErrors = new Array ();//Previous
        var cardname = component.get("v.selectedCardType");
       var creditCardID = component.find('Credit_card_number');
        var cardnumber = creditCardID.get('v.value');
        
        
        ccErrors [0] = "Unknown card type";
        ccErrors [1] = "No card number provided";
        ccErrors [2] = "Credit card number is in invalid format";
        ccErrors [3] = "Credit card number is invalid";
        ccErrors [4] = "Credit card number has an inappropriate number of digits";
        ccErrors [5] = "Warning! This credit card number is associated with a scam attempt";
        var cards = new Array();//previous line 
       
        cards [0] = {name: "Visa", 
                     length: "13,16", 
                     prefixes: "4",
                     checkdigit: true};
        cards [1] = {name: "MasterCard", 
                     length: "16", 
                     prefixes: "51,52,53,54,55",
                     checkdigit: true};
        cards [2] = {name: "AmEx", 
                     length: "15", 
                     prefixes: "34,37",
                     checkdigit: true};
        
       var cardType = -1;
        for (var i=0; i<cards.length; i++) {
            
           if (cardname.toLowerCase () == cards[i].name.toLowerCase()) 
            {                
                cardType = i;
                break;
            }
        }
        
        // If card type not found, report an error
        if (cardType == -1) {
            ccErrorNo = 0;
            return false; 
        }
        
        // Ensure that the user has provided a credit card number
        if (cardnumber.length == 0)  {
            ccErrorNo = 1;
            return false; 
        }
        
        // Now remove any spaces from the credit card number
        cardnumber = cardnumber.replace (/\s/g, "");
        
        // Check that the number is numeric
        var cardNo = cardnumber
        var cardexp = /^[0-9]{13,19}$/;
        if (!cardexp.exec(cardNo))  {
            ccErrorNo = 2;
            return false; 
        }
        // Now check the modulus 10 check digit - if required
        if (cards[cardType].checkdigit) {
            var checksum = 0;                                  // running checksum total
            var mychar = "";                                   // next char to process
            var j = 1;                                         // takes value of 1 or 2
            
            // Process each digit one by one starting at the right
            var calc;
            for (i = cardNo.length - 1; i >= 0; i--) {
                
                // Extract the next digit and multiply by 1 or 2 on alternative digits.
                calc = Number(cardNo.charAt(i)) * j;
                
                // If the result is in two digits add 1 to the checksum total
                if (calc > 9) {
                    checksum = checksum + 1;
                    calc = calc - 10;
                }
                
                // Add the units element to the checksum total
                checksum = checksum + calc;
                
                // Switch the value of j
                if (j ==1) {j = 2} else {j = 1};
            } 
            
            // All done - if checksum is divisible by 10, it is a valid modulus 10.
            // If not, report an error.
            if (checksum % 10 !== 0)  {
                ccErrorNo = 3;
                return false; 
            }
        }  
       // Check it's not a spam number
        if (cardNo == '5490997771092064') { 
            ccErrorNo = 5;
            return false; 
        }
        // The following are the card-specific checks we undertake.
        var LengthValid = false;
        var PrefixValid = false; 
        var undefined; 
        
        // We use these for holding the valid lengths and prefixes of a card type
        var prefix = new Array ();
        var lengths = new Array ();
         prefix = cards[cardType].prefixes.split(",");
        
        // Now see if any of them match what we have in the card number
        for (i=0; i<prefix.length; i++) {
            var exp = new RegExp ("^" + prefix[i]);
            if (exp.test (cardNo)) PrefixValid = true;
        }
        
        // If it isn't a valid prefix there's no point at looking at the length
        if (!PrefixValid) {
            ccErrorNo = 3;
            return false; 
        }
        // See if the length is valid for this card
        lengths = cards[cardType].length.split(",");
        for (j=0; j<lengths.length; j++) {
            if (cardNo.length == lengths[j]) LengthValid = true;
        }
        
        // See if all is OK by seeing if the length was valid. We only check the length if all else was 
        // hunky dory.
        if (!LengthValid) {
            ccErrorNo = 4;
            return false; 
        };   
       // The credit card is in the required format.
        return true;
    }
})
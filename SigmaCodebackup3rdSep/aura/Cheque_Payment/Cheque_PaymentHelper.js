({
	helperMethod : function() {
		
	},
     saveChequePayments : function(component, event)
    {
        var payment = component.get("v.paymentObj");
		payment.sobjectType= 'sigmaerpdev2__Payment__c'; 
         var cashsub = component.get("v.subpayment");
        var receviedamt = component.get("v.ReceivedAmt");     
        //alert('after set'+receviedamt);
        var chequeReceiptNo = component.get('v.chequeReceiptNo');
        
        chequeReceiptNo = component.get('{!v.chequeReceiptNo}');
       
        var receivedFrom = component.get("v.receivedFrom");
        var paymentDate = component.get("v.paymentDate");  
        var paymentDate = new Date();
        var billAmount = component.get("v.billAmount");
        var orderSFId = component.get('v.orderSFId');
        var chkNumber = component.find('chequeNumber');
        var chequeNumber = chkNumber.get('v.value');
         if(chequeNumber ==='' || chequeNumber == null || isNaN(chequeNumber) ||chequeNumber<=0)
        {
           chkNumber.set("v.errors", [{message:"Please enter a valid Cheque number."}]);
             var spinners = component.find('spinner');
             $A.util.removeClass(spinners, 'slds-show');	
             return null; 
        }
        else
        {
            chkNumber.set("v.errors", null);
        }
        var bnkName = component.find('bankName');
        var bankName = bnkName.get('v.value');
        if(bankName==='' || bankName ==null )
        {
           bnkName.set("v.errors", [{message:"Please enter a Bank name."}]);
      		 var spinners1 = component.find('spinner');
             $A.util.removeClass(spinners1, 'slds-show');	
             return null; 
        }
        else
        {
            bnkName.set("v.errors", null);
        }
         
        var chkdate = component.find('chequeDate');
        var chequeDate = chkdate.get('v.value');
        var arr = chequeDate.split('-');;
      
        var input = arr[2]+'/'+arr[1]+'/'+arr[0];
        var pattern =/^([0-9]{2})\/([0-9]{2})\/([0-9]{4})$/;

        if(chequeDate=== '' || chequeDate == null)
        {
             chkdate.set("v.errors", [{message:"Please select Cheque date"}]);
             var spinners2 = component.find('spinner');
             $A.util.removeClass(spinners2, 'slds-show');	
             return null;
       
        }else
        {
            chkdate.set("v.errors", null);
        }
        //validation on cheque date if user select the past date 
        var chequedate = component.get("v.paymentObj.sigmaerpdev2__Cheque_Date__c");
       // alert('chequedate>>'+chequedate);
        var today = new Date();
        component.set('v.today', today.getFullYear()+ "-" +(today.getMonth() + 1)+ "-" + today.getDate() );
        var date = component.get("v.today");
        
        var someDate = new Date(component.get("v.paymentObj.sigmaerpdev2__Cheque_Date__c"));
       
        component.set('v.Orderdate', someDate.getFullYear()+ "-" +(someDate.getMonth() + 1)+ "-" + someDate.getDate() );
       
       
        var orderdate = component.get("v.Orderdate");
      // alert('orderdate::'+orderdate);
       //alert('date::'+date);
             if(Date.parse(orderdate) < Date.parse(date)){ 
         //   alert('in');
                 // if(chequedate < System.today()){  
              chkdate.set("v.errors", [{message:"Cheque date Should be greater than Today."}]);
			 var spinners2 = component.find('spinner');
             $A.util.removeClass(spinners2, 'slds-show');	
             return null;                     
        }else{             
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }
        
    
        var accountSFId = component.get('v.recordId');
       
      if(cashsub==true)
        {
          // alert('inside if>>');
             var payments = component.get("v.paymentObj");
             component.set("v.paymentlist",payments);
            payments.sigmaerpdev2__Amount_Recevied__c = receviedamt;
          var paylist=  component.get("v.paymentlist");
             //alert('paylist>>'+JSON.strigify(paylist));
        var action = component.get("c.savesubscriptionChequePayment");  
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
                
                if (returnValues == null || returnValues == '')
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
        }else
        {
           // alert('inside cheque>>');
             var action = component.get("c.saveChequePayment");  
             payment.sigmaerpdev2__Amount_Recevied__c = receviedamt;
            var regid =   component.get("v.regid"); 
		action.setParams({
            "payment" : payment,
             "regid" : regid
        });
     
        action.setCallback(this, function(response) 
        {
            var state = response.getState();
            
            // Callback succeeded
            if (component.isValid() && state === "SUCCESS")
            {               
                var returnValues = response.getReturnValue();
              
                if (returnValues == null || returnValues == '')
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
         document.getElementById("Accspinner").style.display = "block";
        $A.enqueueAction(action); 

	}

})
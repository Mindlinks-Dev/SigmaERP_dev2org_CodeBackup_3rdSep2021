({    
    
    myAction : function(component, event, helper){
       
        var sid = component.get("v.recordId");  
       // alert('sid1>>>'+sid);
       if(sid!=null && sid !=''){       
        var action = component.get("c.orderRecords");
          
        action.setParams({ 
            "Ids": sid            
        });        
        action.setCallback( this, function(a){            
            var state = a.getState();          
           // alert('state>>>>'+state);
            if (state === "SUCCESS")
            {
               // 
                var StappOrder = a.getReturnValue();
                // validation code                 
             //  alert('SigmaOrder2>>'+JSON.stringify(StappOrder));
                var valid = component.get("c.ordervalid"); 
                valid.setCallback(this,function(a){
                    var validstate = a.getState();
                    if(state == "SUCCESS"){                      
                        if(a.getReturnValue() != null){
                            var ValRes = a.getReturnValue();
                 			/*if(StappOrder.sigmaerpdev2__Order_Created_Via__c == 'POS' && 
                               (ValRes.ou.sigmaerpdev2__Standard_object__c || ValRes.ou.sigmaerpdev2__Sigma_order__c == false ||
                                ValRes.OP.sigmaerpdev2__Subscription_Product__c ||  ValRes.OP.sigmaerpdev2__Subscription_Renewal__c ||
                                ValRes.tmi.sigmaerpdev2__Order__c||ValRes.tmi.sigmaerpdev2__Proposal__c||ValRes.tmi.sigmaerpdev2__Proposal_for_Products__c||ValRes.tmi.sigmaerpdev2__Proposal_to_Order__c
                               )){
                                    var msg = "Please Check SigmaOrder in Order Usage Custom settings";
                                    component.set("v.errorMsg", msg);
                                    component.set("v.isError",true);
                                    return;
                            	}                            	
                            	else if((StappOrder.sigmaerpdev2__Order_Created_Via__c == 'Time Based Inventory'  && StappOrder.sigmaerpdev2__Proposals__c == null)&& 
                                  (ValRes.ou.sigmaerpdev2__Standard_object__c || ValRes.ou.sigmaerpdev2__Sigma_order__c ||
                                   ValRes.OP.sigmaerpdev2__Subscription_Product__c|| ValRes.OP.sigmaerpdev2__Subscription_Renewal__c||
                                   ValRes.tmi.sigmaerpdev2__Order__c == false||ValRes.tmi.sigmaerpdev2__Proposal__c||ValRes.tmi.sigmaerpdev2__Proposal_for_Products__c||ValRes.tmi.sigmaerpdev2__Proposal_to_Order__c
                                  )){
                                     var msg = "Please Check SalesOrderTBI in  Time Based Inventory  custom settings";
                                    component.set("v.errorMsg", msg);
                                    component.set("v.isError",true);
                                    return;                                
                            	}
                                else if((StappOrder.sigmaerpdev2__Order_Created_Via__c == 'Time Based Inventory' && StappOrder.sigmaerpdev2__Proposals__c != null)&& 
                                  (ValRes.ou.sigmaerpdev2__Standard_object__c || ValRes.ou.sigmaerpdev2__Sigma_order__c ||
                                   ValRes.OP.sigmaerpdev2__Subscription_Product__c||  ValRes.OP.sigmaerpdev2__Subscription_Renewal__c||
                                   ValRes.tmi.sigmaerpdev2__Order__c||ValRes.tmi.sigmaerpdev2__Proposal__c ||ValRes.tmi.sigmaerpdev2__Proposal_for_Products__c||ValRes.tmi.sigmaerpdev2__Proposal_to_Order__c == false
                                  )){
                                        var msg = "Please Check Proposal for Order in  Time Based Inventory  custom settings";
                                    component.set("v.errorMsg", msg);
                                    component.set("v.isError",true);
                                    return;
                                 }
                    		else{
                                component.set("v.isError",false);
                                component.set("v.errorMsg", "");
                            }*/                            
                        }                        
                    }
                });
                $A.enqueueAction(valid);
                // ends here
               
                component.set("v.recordId",StappOrder.Id);
                component.set("v.isPayment",StappOrder.sigmaerpdev2__Is_Payment_Made__c); 
                component.set("v.ordercreatedvia",StappOrder.sigmaerpdev2__Order_Created_Via__c);
               // alert('ordercreatedvia3>>'+JSON.stringify(component.get("v.ordercreatedvia",StappOrder.sigmaerpdev2__Order_Created_Via__c)));
                var paymentmaid = component.get("v.isPayment");
              //  alert('paymentmaid4::'+paymentmaid);
                var delqty = JSON.stringify(StappOrder.sigmaerpdev2__Order_Lines__r);
                
               // alert(StappOrder.sigmaerpdev2__Orders_Status__c==='Pending');
               // alert(StappOrder.sigmaerpdev2__Orders_Status__c === 'Order Confirmed');
               // alert(StappOrder.sigmaerpdev2__Orders_Status__c === 'Delivered');
              //  alert(StappOrder.sigmaerpdev2__Is_Payment_Made__c === false);
               // alert(StappOrder.RecordType.Name ==='Rental Order');
               // alert(StappOrder.sigmaerpdev2__Due_Amount__c>0);
                if(StappOrder.sigmaerpdev2__Due_Amount__c <= 0){
                   alert('Payment is already done for this order.');
                   var backdrop = component.find('backdrop');
                   $A.util.removeClass(backdrop, 'slds-hide');
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": sid,
                        "slideDevName": "Detail"
                    });
                    navEvt.fire();
                      
                }  
                 else if(StappOrder.sigmaerpdev2__Orders_Status__c == 'Canceled'){
                   alert('Cannot accept Payment for Cancelled Order');
                   var backdrop = component.find('backdrop');
                   $A.util.removeClass(backdrop, 'slds-hide');
                  $A.util.removeClass(backdrop, 'slds-hide');
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": sid,
                        "slideDevName": "Detail"
                    });
                    navEvt.fire();
                      
                }   
                
                     else if(StappOrder.sigmaerpdev2__Orders_Status__c === 'Pending' ||(StappOrder.sigmaerpdev2__Orders_Status__c === 'Order Confirmed'|| StappOrder.sigmaerpdev2__Orders_Status__c === 'Delivered' || StappOrder.sigmaerpdev2__Orders_Status__c === 'Shipped'  && StappOrder.sigmaerpdev2__Is_Payment_Made__c === false)||(StappOrder.sigmaerpdev2__Orders_Status__c === 'Order Confirmed' && StappOrder.RecordType.Name ==='Rental Order')||(StappOrder.sigmaerpdev2__Orders_Status__c ==='Order Confirmed' && StappOrder.sigmaerpdev2__Due_Amount__c > 0)|| StappOrder.sigmaerpdev2__Orders_Status__c === 'Submitted')
                {                  
                   // alert('inside payment5');                 
				    component.set("v.AccountId",StappOrder.sigmaerpdev2__AccountId__r.Id);
                    component.set("v.contactName",StappOrder.sigmaerpdev2__AccountId__r.Name);
                    component.set("v.billingPerson",StappOrder.sigmaerpdev2__Billing_Person__c);
                    if(StappOrder.sigmaerpdev2__Net_Amount__c == undefined)
                    {
                        component.set("v.totalBillAmountValue", StappOrder.sigmaerpdev2__Due_Amount__c);
                      //  alert('undefined6::::'+JSON.stringify(StappOrder.sigmaerpdev2__Due_Amount__c));
                    }
                    else
                    {
                        component.set("v.TotalProductAmount", StappOrder.sigmaerpdev2__Due_Amount__c); 
                      //  alert('defined7::::'+JSON.stringify(StappOrder.sigmaerpdev2__Due_Amount__c));
                        var action1 = component.get("c.getTax");
                        var customerSFId = component.get('v.AccountId');
                      //  alert('customerSFId8>>>'+customerSFId);
                        action1.setParams({
                            "customerSFID" : customerSFId 
                        });
                        action1.setCallback(this, function(response) {
                            var state = response.getState();
                            if (component.isValid() && state === 'SUCCESS')
                            {
                                var matches = response.getReturnValue();
                                if (matches.length === 0)
                                {
                                    component.set('v.FederalTax', null);
                                    component.set('v.StateTax', null);
                                    component.set('v.TaxType', null);
                                    component.set('v.TaxOnBillAmount', null);
                                    return;
                                }
                                
                                var FederalTax = matches[0].sigmaerpdev2__Tax_Amount__c;
                                var federalTaxType = matches[0].sigmaerpdev2__Type__c;
                                var StateTax = matches[1].sigmaerpdev2__Tax_Amount__c;
                                var StateTaxType = matches[1].sigmaerpdev2__Type__c;
                                var netamt=component.get('v.TotalProductAmount');
                                var BillAmount =StappOrder.sigmaerpdev2__Net_Amount__c ;
                                var TaxOnBillAmount = '';
                                var TotalBillAmount = '';
                                var NetTotalBillAmount = '';
                                
                                if(federalTaxType === 'Percentage'){
                                    TaxOnBillAmount = (BillAmount * FederalTax)/100;
                                }else{
                                    TaxOnBillAmount = BillAmount + FederalTax;
                                }
                                
                                if(StateTaxType === 'Percentage'){
                                    TaxOnBillAmount = (TaxOnBillAmount + (BillAmount * StateTax)/100);
                                }else{
                                    TaxOnBillAmount = (TaxOnBillAmount + (BillAmount + StateTax));
                                }
                                
                                TaxOnBillAmount = parseFloat(TaxOnBillAmount).toFixed(2);
                                component.set('v.FederalTax', FederalTax);
                                component.set('v.StateTax', StateTax);
                                component.set('v.flatTaxType',federalTaxType);
                                component.set('v.stateTaxType',StateTaxType);
                                component.set('v.TaxOnBillAmount', TaxOnBillAmount);
                                
                                NetTotalBillAmount = parseFloat(netamt);
                                NetTotalBillAmount = parseFloat(NetTotalBillAmount).toFixed(2);
                                component.set('v.totalBillAmountValue',NetTotalBillAmount);
                                //alert('netamount>>'+component.get('v.totalBillAmountValue'));
                            }
                            else if (state === 'ERROR') // Handle any error by reporting it
                            {
                                var errors = response.getError();
                                if (errors) 
                                {
                                    if (errors[0] && errors[0].message) 
                                    {
                                        alert('Error'+errors[0].message);
                                        
                                    }
                                }
                                else
                                {
                                    alert('Error Unknown Error:');
                                    
                                }
                            }  
                        }); 
                        
                        $A.enqueueAction(action1); 
                    } 
                }
              //  alert('Came out');
                //getCurrency(); 
            }                           
        });
        
        $A.enqueueAction(action);
        
        
        function getCurrency()
        { 
            var curr = component.get('c.getCurrency');  
           // alert('getCurrency::'+curr);
            curr.setCallback(this, function(response) {
                var state = response.getState();                
                if (component.isValid() && state === "SUCCESS"){
                    var retValues = response.getReturnValue();
                    
                    if (retValues.length === 0)
                    {
                        component.set('v.currencySymbol', null);
                        return;
                    }
                    else{
                        component.set('v.currencySymbol', retValues.sigmaerpdev2__Currency__c); 
                    }
                    
                }                
                else if (state === "ERROR") 
                {  
                    
                    var errors = response.getError();                
                    if (errors) 
                    {
                        if (errors[0] && errors[0].message) 
                        {
                            
                        }
                    }
                    else
                    {
                        
                    }
                }
            });
            $A.enqueueAction(curr);
        }
        }
        
    }
    
})
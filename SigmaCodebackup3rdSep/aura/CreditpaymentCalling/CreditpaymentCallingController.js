({    
    
    myAction : function(component, event, helper) 
    {
       // var sid = component.get("v.recordId");
         var sid = component.get("v.selectedSalesInvoice");
        alert('sid::'+JSON.stringify(sid));
        var sendingList=[];
         for(var i=0;i<sid.length;i++){
         if(sid[i].selected)
            sendingList.push(sid[i].Id);
         }
       
        if(sendingList!=null && sendingList !='')
        {
       
        var action = component.get("c.OrderedProduct");
        action.setParams
        ({ 
            "Ids": JSON.stringify(sendingList)          
        });
        
        action.setCallback( this, function(a){            
            var state = a.getState();
            alert('state::'+state);
            if (state === "SUCCESS")
            {
                 var StappOrder = a.getReturnValue();
                // validation code
                 alert('sid;::'+JSON.stringify(StappOrder));
                var valid = component.get("c.ordervalid"); 
                valid.setCallback(this,function(a){
                    var validstate = a.getState();
                    if(state == "SUCCESS"){
                       alert('Success'+a.getReturnValue());
                        if(a.getReturnValue() != null){
                            var ValRes = a.getReturnValue();
                 		if(StappOrder.sigmaerpdev__Order_Created_Via__c == 'POS' && 
                               (ValRes.ou.sigmaerpdev__Standard_object__c || ValRes.ou.sigmaerpdev__Sigma_order__c == false ||
                                ValRes.OP.sigmaerpdev__Subscription_Product__c ||  ValRes.OP.sigmaerpdev__Subscription_Renewal__c ||
                                ValRes.tmi.sigmaerpdev__Order__c||ValRes.tmi.sigmaerpdev__Proposal__c||ValRes.tmi.sigmaerpdev__Proposal_for_Products__c||ValRes.tmi.sigmaerpdev__Proposal_to_Order__c
                               )){
                                var msg = "Please Check SigmaOrder in Order Usage Custom settings";
                                component.set("v.errorMsg", msg);
                                component.set("v.isError",true);
                                return;
                            }else if(StappOrder.sigmaerpdev__Order_Created_Via__c == 'Subscription' && 
                  (ValRes.ou.sigmaerpdev__Standard_object__c || ValRes.ou.sigmaerpdev__Sigma_order__c ||
                   (ValRes.OP.sigmaerpdev__Subscription_Product__c == false && ValRes.OP.sigmaerpdev__Subscription_Renewal__c == false)||
                   ValRes.tmi.sigmaerpdev__Order__c||ValRes.tmi.sigmaerpdev__Proposal__c||ValRes.tmi.sigmaerpdev__Proposal_for_Products__c||ValRes.tmi.sigmaerpdev__Proposal_to_Order__c
                  )){
                     var msg = "Please Check Order API in custom settings";
                    component.set("v.errorMsg", msg);
                    component.set("v.isError",true);
                    return;
                    
                }else if((StappOrder.sigmaerpdev__Order_Created_Via__c == 'Time Based Inventory'  && StappOrder.sigmaerpdev__Proposals__c == null)&& 
                  (ValRes.ou.sigmaerpdev__Standard_object__c || ValRes.ou.sigmaerpdev__Sigma_order__c ||
                   ValRes.OP.sigmaerpdev__Subscription_Product__c|| ValRes.OP.sigmaerpdev__Subscription_Renewal__c||
                   ValRes.tmi.sigmaerpdev__Order__c == false||ValRes.tmi.sigmaerpdev__Proposal__c||ValRes.tmi.sigmaerpdev__Proposal_for_Products__c||ValRes.tmi.sigmaerpdev__Proposal_to_Order__c
                  )){
                     var msg = "Please Check SalesOrderTBI in  Time Based Inventory  custom settings";
                    component.set("v.errorMsg", msg);
                    component.set("v.isError",true);
                    return;
                    
                }else if((StappOrder.sigmaerpdev__Order_Created_Via__c == 'Time Based Inventory' && StappOrder.sigmaerpdev__Proposals__c != null)&& 
                  (ValRes.ou.sigmaerpdev__Standard_object__c || ValRes.ou.sigmaerpdev__Sigma_order__c ||
                   ValRes.OP.sigmaerpdev__Subscription_Product__c||  ValRes.OP.sigmaerpdev__Subscription_Renewal__c||
                   ValRes.tmi.sigmaerpdev__Order__c||ValRes.tmi.sigmaerpdev__Proposal__c ||ValRes.tmi.sigmaerpdev__Proposal_for_Products__c||ValRes.tmi.sigmaerpdev__Proposal_to_Order__c == false
                  )){
                        var msg = "Please Check Proposal for Order in  Time Based Inventory  custom settings";
                    component.set("v.errorMsg", msg);
                    component.set("v.isError",true);
                    return;
                    }else if((StappOrder.sigmaerpdev__Order_Created_Via__c == 'Proposal')&& 
                  (ValRes.ou.sigmaerpdev__Standard_object__c || ValRes.ou.sigmaerpdev__Sigma_order__c ||
                   ValRes.OP.sigmaerpdev__Subscription_Product__c||  ValRes.OP.sigmaerpdev__Subscription_Renewal__c||
                   ValRes.tmi.sigmaerpdev__Order__c||ValRes.tmi.sigmaerpdev__Proposal__c ||ValRes.tmi.sigmaerpdev__Proposal_for_Products__c == false||ValRes.tmi.sigmaerpdev__Proposal_to_Order__c
                  )){
                        var msg = "Please Check Proposal for product in  Time Based Inventory  custom settings";
                    component.set("v.errorMsg", msg);
                    component.set("v.isError",true);
                    return;
                    }
                    else{
                                component.set("v.isError",false);
                                component.set("v.errorMsg", "");
                            }
                            
                        }
                        
                    }
                  
                    
                });
                $A.enqueueAction(valid);
                // ends here
               
                //component.set("v.recordId",StappOrder.Id);
                component.set("v.isPayment",StappOrder.sigmaerpdev__Is_Payment_Made__c); 
                component.set("v.ordercreatedvia",StappOrder.sigmaerpdev__Order_Created_Via__c);
                //alert('xsdasfasfdsgfd'+component.set("v.ordercreatedvia",StappOrder.sigmaerpdev__Order_Created_Via__c));
                var paymentmaid = component.get("v.isPayment");
                //alert('paymentmaid::'+paymentmaid);
                var delqty = JSON.stringify(StappOrder.sigmaerpdev__Order_Lines__r);
                var temp=[];
                var dueamount=0;
                var netamount=0;
                for(i=0;i<StappOrder.length;i++)
                {
                    dueamount+=StappOrder[i].sigmaerpdev__Due_Amount__c;
                    netamount+=StappOrder[i].sigmaerpdev__Net_Amount__c                    
                    temp.push(StappOrder[i].Id)
                }
                component.set("v.recordId",temp);
                alert('red id>. '+component.get("v.recordId"));
                alert('dueamount:'+dueamount);
                alert('Netamount'+netamount);
                if(StappOrder[0].sigmaerpdev__Due_Amount__c <= 0)
                {
                  /*  alert('Payment is allready done for this order');
                   var backdrop = component.find('backdrop');
                   $A.util.removeClass(backdrop, 'slds-hide');  */  
                }
                
                else if(StappOrder[0].sigmaerpdev__Orders_Status__c === 'Pending' ||(StappOrder[0].sigmaerpdev__Orders_Status__c === 'Order Confirmed' && StappOrder[0].sigmaerpdev__Is_Payment_Made__c === false)||(StappOrder[0].sigmaerpdev__Orders_Status__c === 'Order Confirmed' && StappOrder[0].RecordType.Name ==='Rental Order'))
                {
                    alert('payment');
                    component.set("v.AccountId",StappOrder[0].sigmaerpdev__AccountId__r.Id);
                    component.set("v.contactName",StappOrder[0].sigmaerpdev__AccountId__r.Name);
                    component.set("v.billingPerson",StappOrder[0].sigmaerpdev__Billing_Person__c);
                  // alert('contactname'+component.get("v.contactName"));
                    if(netamount==undefined)
                    {
                        component.set("v.totalBillAmountValue", dueamount);
                        //alert('dgdgxcsfdf:'+JSON.stringify(StappOrder.sigmaerpdev__Due_Amount__c));
                    }
                    else
                    {
                        component.set("v.TotalProductAmount", dueamount); 
                        // alert('dgdgxcsfdf:'+JSON.stringify(StappOrder.sigmaerpdev__Due_Amount__c));
                       
                        var action1 = component.get("c.getTax");
                        var customerSFId = [];
                        customerSFId = component.get('v.AccountId');
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
                                
                                var FederalTax = matches[0].sigmaerpdev__Tax_Amount__c;
                                var federalTaxType = matches[0].sigmaerpdev__Type__c;
                                var StateTax = matches[1].sigmaerpdev__Tax_Amount__c;
                                var StateTaxType = matches[1].sigmaerpdev__Type__c;
                                var netamt=component.get('v.TotalProductAmount');
                                var BillAmount =netamount ;
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
                                
                                alert('TAX'+ component.get('v.TaxOnBillAmount'));
                                NetTotalBillAmount = parseFloat(netamt);
                                NetTotalBillAmount = parseFloat(NetTotalBillAmount).toFixed(2);
                                component.set('v.totalBillAmountValue',NetTotalBillAmount);
                                
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
                //getCurrency(); 
            }                           
        });
        
        $A.enqueueAction(action);
        
        
        function getCurrency()
        { 
            var curr = component.get('c.getCurrency');  
            //alert('getCurrency::'+curr);
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
                        component.set('v.currencySymbol', retValues.sigmaerpdev__Currency__c); 
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
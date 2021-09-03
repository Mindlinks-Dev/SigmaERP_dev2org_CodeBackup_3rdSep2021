({
    myAction : function(component, event, helper) 
    {
      var sid = component.get("v.recordId");
         
     
        if(sid!=''&& sid!=null)
        {
        
       /* //******validation starts from here for subscription payment, added by rashmi**********
        var validresult = component.get("c.custvalidOrder");
        validresult.setCallback(this,function(a){
            if(a.getReturnValue() != null){
                var result = a.getReturnValue();
                if(result.ou.sigmaerpdev2__Standard_object__c == false || result.ou.sigmaerpdev2__Sigma_order__c||
                   result.OP.sigmaerpdev2__Subscription_Product__c ||  result.OP.sigmaerpdev2__Subscription_Renewal__c ||
                   result.tmi.sigmaerpdev2__Order__c||result.tmi.sigmaerpdev2__Proposal__c||result.tmi.sigmaerpdev2__Proposal_for_Products__c||result.tmi.sigmaerpdev2__Proposal_to_Order__c
                  ){
                    var msg="Please check Standard Order in OrderUsage Custom Settings"
                    component.set("v.ErrorText",msg);
                    component.set("v.errorflag",true);
                    return;
                }else{
                    component.set("v.errorflag",false);
                    component.set("v.ErrorText","");
                    
                } 
            }
        });
        $A.enqueueAction(validresult);*/
        //**** Ends here****
        
       
        var action = component.get("c.orderRecords");
        action.setParams
        ({ 
            "Ids": sid            
        });
        
        action.setCallback( this, function(a){            
            var state = a.getState();
           	if (state === "SUCCESS")
            {       	
                        var StappOrder = a.getReturnValue();
                //alert('standard>>'+JSON.stringify(StappOrder));
                component.set("v.recordId",StappOrder.Id);
                component.set("v.isPayment",StappOrder.sigmaerpdev2__Is_Payment_Made__c); 
                var paymentmaid = component.get("v.isPayment");
               	if(StappOrder.sigmaerpdev2__Due_Amount__c <= 0)
                {
                    alert('payment is already done for this order');
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
                else
                {
                    if(StappOrder.sigmaerpdev2__Orders_Status__c === 'Pending' || (StappOrder.sigmaerpdev2__Orders_Status__c === 'Order Confirmed'|| StappOrder.sigmaerpdev2__Orders_Status__c === 'Delivered' || StappOrder.sigmaerpdev2__Orders_Status__c === 'Shipped'  && StappOrder.sigmaerpdev2__Is_Payment_Made__c === false))
                    {
                        component.set("v.AccountId",StappOrder.AccountId);
                        component.set("v.contactName",StappOrder.Account.Name);
                        component.set("v.billingPerson",StappOrder.sigmaerpdev2__Billing_Person__c);
                        if(StappOrder.sigmaerpdev2__Net_Amount__c==undefined)
                        {
                           component.set("v.totalBillAmountValue", StappOrder.sigmaerpdev2__Due_Amount__c);
                        }
                        else
                        {
                            component.set("v.TotalProductAmount", StappOrder.sigmaerpdev2__Due_Amount__c); 
                           	var action1 = component.get("c.getTax");
                            var customerSFId = component.get('v.AccountId');
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
                                    var BillAmount = StappOrder.sigmaerpdev2__TotalAmount__c;
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
                }
                
            }                           
        });
        
        $A.enqueueAction(action);  
    }
       
        } 
})
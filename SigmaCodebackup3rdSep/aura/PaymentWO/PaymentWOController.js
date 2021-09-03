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
          //  alert('statesss12>>>>'+state);
            if (state === "SUCCESS")
            {
              //  alert('state>>>>'+state);
                var Workorder = a.getReturnValue();
                // validation code                 
               //alert('wrkordr>>'+JSON.stringify(Workorder));
                
               
                component.set("v.recordId",Workorder.Id);
                component.set("v.isPayment",Workorder.sigmaerpdev2__Is_Payment_Made__c); 
                var paymentmaid = component.get("v.isPayment");
              // alert('paymentmaid4::'+paymentmaid);
               
               
              /* if(Workorder.sigmaerpdev2__Due_Amount__c <= 0){
                   alert('Payment is already done for this work order.');
                   var backdrop = component.find('backdrop');
                   $A.util.removeClass(backdrop, 'slds-hide');
                   window.location.reload();
                      
                } */
                  if(paymentmaid == true){
                   alert('Payment is already done for this work order.');
                   var backdrop = component.find('backdrop');
                   $A.util.removeClass(backdrop, 'slds-hide');
                   window.location.reload();
                      
                } 
                
                  else if(Workorder.Status__c == 'Rejected'){
                   alert('Cannot accept Payment for Rejected Work Order');
                   var backdrop = component.find('backdrop');
                   $A.util.removeClass(backdrop, 'slds-hide');
                   window.location.reload();
                      
                }   
                
                     else if((Workorder.sigmaerpdev2__Status__c === 'Completed' && Workorder.sigmaerpdev2__Is_Payment_Made__c === false)||(Workorder.Status__c ==='Completed' && Workorder.sigmaerpdev2__Due_Amount__c > 0)||(Workorder.sigmaerpdev2__Status__c === 'Another Visit Needed' && Workorder.sigmaerpdev2__Is_Payment_Made__c === false)||(Workorder.Status__c ==='Another Visit Needed' && Workorder.sigmaerpdev2__Due_Amount__c > 0)||(Workorder.sigmaerpdev2__Status__c === 'Invoiced to Customer' && Workorder.sigmaerpdev2__Is_Payment_Made__c === false)||(Workorder.Status__c ==='Invoiced to Customer' && Workorder.sigmaerpdev2__Due_Amount__c > 0))
                {                  
                   // alert('inside payment5');                 
				    component.set("v.AccountId",Workorder.sigmaerpdev2__Account__r.Id);
                    component.set("v.contactName",Workorder.sigmaerpdev2__Account__r.Name);
                    component.set("v.billingPerson",Workorder.sigmaerpdev2__Account__r.Name);
                    if(Workorder.sigmaerpdev2__TotalAmount__c == 0)
                    {
                        alert('No due amount to Pay');
                         window.location.reload();
                       // component.set("v.totalBillAmountValue", Workorder.sigmaerpdev2__Due_Amount__c);
                      //  alert('undefined6::::'+JSON.stringify(Workorder.sigmaerpdev2__Due_Amount__c));
                    }
                    else
                    {
                        //alert('inside else>>'+Workorder.sigmaerpdev2__TotalAmount__c);
                        component.set("v.totalBillAmountValue", Workorder.sigmaerpdev2__Due_Amount__c);
                       //alert('inside else>>'+component.get("v.totalBillAmountValue"));
                        
                        
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
                                var netamt=component.get('v.totalBillAmountValue');
                                var BillAmount =Workorder.sigmaerpdev2__TotalAmount__c ;
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
              
            } 
				else if(state === "ERROR") {
					
                var errors = a.getError();
                alert('Error occured while fetching Customer Informations : '+JSON.stringify(errors));
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
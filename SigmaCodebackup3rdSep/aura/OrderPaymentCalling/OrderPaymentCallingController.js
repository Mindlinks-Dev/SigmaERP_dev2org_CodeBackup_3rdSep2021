({
	myAction : function(component, event, helper) {
		var orderline = component.get('v.selectedOrderList');
        var accID = component.get("v.Accid");
       
        var orderdata;
        if(component.get('v.SigmaOrder'))
        {
        	var action = component.get("c.fetchsigmaorder");
        	action.setParams({ 
            "OrderId" : orderline
        	});  
            
            action.setCallback(this, function (response) {
            var state = response.getState();

            if (state==="SUCCESS") {
               orderdata = response.getReturnValue();
                component.set("v.selectedOrderList", orderdata);  
           	var totalamount = 0;
        	for(var i=0;i<orderdata.length;i++)
            {
                totalamount+= orderdata[i].sigmaerpdev2__Due_Amount__c;
            }
        	component.set("v.TotalOrderAmount", totalamount);    
             
            }
                 });
       		
        }
        else if(component.get('v.StndOrder'))
        {
            
            var action = component.get("c.fetchstdorder");
        	action.setParams({ 
            "OrderId" : orderline
        	}); 
             action.setCallback(this, function (response) {
            var state = response.getState();
				
            if (state==="SUCCESS") {
                
               orderdata = response.getReturnValue();
               component.set("v.selectedOrderList", orderdata); 
                
           	var totalamount = 0;
        	for(var i=0;i<orderdata.length;i++)
            {
                totalamount+= orderdata[i].sigmaerpdev2__Due_Amount__c;
            }
        	component.set("v.TotalOrderAmount", totalamount);  
              
            }
                 });
       		
        }
        $A.enqueueAction(action);
        
        var action1 = component.get("c.getTax");
       
        action1.setParams({
            "customerSFID" : accID 
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
                                var BillAmount =component.get("v.TotalOrderAmount"); ;
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
                            }
             }); 
                        
        $A.enqueueAction(action1); 

	}
})
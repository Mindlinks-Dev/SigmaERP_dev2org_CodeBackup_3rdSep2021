({
    myAction : function(component, event, helper) {
        // ** validation code for subscription payment, added by rashmi on 27-08-2019
        var sid = component.get("v.recordId");
        
        component.set("v.isError",false);
        component.set("v.errorMsg", ""); 
        var action = component.get("c.subintervelRecords");
        
        action.setParams
        ({ 
            "Ids": sid            
        });
        action.setCallback( this, function(a){	            
            var state = a.getState();
            
            if (state === "SUCCESS")
            {
                var subOrder = a.getReturnValue();
                //alert('subOrder'+JSON.stringify(subOrder));
                component.set("v.recordId",subOrder.Id);
                component.set("v.AccountId",subOrder.sigmaerpdev2__Customer__r.Id);
                
                component.set("v.contactName",subOrder.sigmaerpdev2__Customer__r.Name);
                if(subOrder.sigmaerpdev2__Account_Subscription__r.sigmaerpdev2__Status__c!='Active')
                {
                    var msg = "Your Subscription has Inactive,not Possible to do payment.";
                    component.set("v.errorMsg", msg);
                    component.set("v.isError",true);
                    return;
                }
                if(subOrder.sigmaerpdev2__Usage_Type__c=='Product')
                {
                    var msg = "Create Order for Proceed to Payment.";
                    component.set("v.errorMsg", msg);
                    component.set("v.isError",true);
                    return;
                }
                else if(subOrder.sigmaerpdev2__Payment_Status__c === 'Not Paid')
                {
                    component.set("v.amountTobeCharged",subOrder.sigmaerpdev2__Amount__c);
                }
                    else if(subOrder.sigmaerpdev2__Payment_Status__c === 'Partial Paid')
                    {
                        component.set("v.amountTobeCharged",subOrder.sigmaerpdev2__Due_Amount__c);//due ammount fetch in apex-formula feild default =0.0
                    }
                        else
                        { 
                            if(subOrder.sigmaerpdev2__Payment_Status__c === 'Paid')
                            {
                                var msg = "payment has already been done for this interval.";
                                component.set("v.errorMsg", msg);
                                component.set("v.isError",true);
                                return;
                            }
                            else{
                                component.set("v.isError",false);
                                component.set("v.errorMsg", "");
                            }
                            
                        }
                
                //getCurrency();                 
                
            }                           
        });	
        $A.enqueueAction(action);						
        
        //** Ends here
    }
    /* myAction : function(component, event, helper) {
   // ** validation code from Custom settings, added by sandhya
   var sid = component.get("v.recordId");
	var OrderValid = component.get("c.OrderValid");
	OrderValid.setCallback( this, function(a){
		if(a.getReturnValue() != null)
		{
           var result = a.getReturnValue();
		//	alert(result+ JSON.Stringify(result));
		   if(result.OP.sigmaerpdev2__Subscription_Product__c == false && result.OP.sigmaerpdev2__Subscription_Renewal__c == false)
		   {
				var msg = "Please Check Subscription Setting in custom settings";
				component.set("v.errorMsg", msg);
				component.set("v.isError",true);
				return;
			}else if(result.ou.sigmaerpdev2__Sigma_order__c || result.ou.sigmaerpdev2__Standard_object__c)
			{
				var msg = "Please unCheck Orderusage in custom settings";
				component.set("v.errorMsg", msg);
				component.set("v.isError",true);
				return; 
			}else
			{
           		if(result.tmi.sigmaerpdev2__Order__c || result.tmi.sigmaerpdev2__Proposal__c || result.tmi.sigmaerpdev2__Proposal_for_Products__c|| result.tmi.sigmaerpdev2__Proposal_to_Order__c)
				{
					var msg = "Please unCheck Time Based Inventory in custom settings";
					component.set("v.errorMsg", msg);
					component.set("v.isError",true);
					return;
				}
                 else
				{
					component.set("v.isError",false);
					component.set("v.errorMsg", ""); 
						var action = component.get("c.subintervelRecords");
	
					action.setParams
					({ 
						"Ids": sid            
					});
					action.setCallback( this, function(a){	            
						var state = a.getState();
						
						if (state === "SUCCESS")
						{
							var subOrder = a.getReturnValue();
							//alert('subOrder'+JSON.stringify(subOrder));
							component.set("v.recordId",subOrder.Id);
							component.set("v.AccountId",subOrder.sigmaerpdev2__Customer__r.Id);
							
							component.set("v.contactName",subOrder.sigmaerpdev2__Customer__r.Name);
							if(subOrder.sigmaerpdev2__Account_Subscription__r.sigmaerpdev2__Status__c!='Active')
							{
								var msg = "Your Subscription has Inactive,not Possible to do payment.";
								component.set("v.errorMsg", msg);
								component.set("v.isError",true);
								return;
							}
							if(subOrder.sigmaerpdev2__Usage_Type__c=='Product')
							{
								var msg = "Create Order for Proceed to Payment.";
								component.set("v.errorMsg", msg);
								component.set("v.isError",true);
								return;
							}
							else if(subOrder.sigmaerpdev2__Payment_Status__c === 'Not Paid')
							{
								component.set("v.amountTobeCharged",subOrder.sigmaerpdev2__next_Billing_Amount__c);
							}
							else if(subOrder.sigmaerpdev2__Payment_Status__c === 'Partial Paid')
							{
								component.set("v.amountTobeCharged",subOrder.sigmaerpdev2__Due_Amount__c);//due ammount fetch in apex-formula feild default =0.0
							}
								else
								{ 
									if(subOrder.sigmaerpdev2__Payment_Status__c === 'Paid')
									{
										var msg = "payment has already been done for this interval.";
										component.set("v.errorMsg", msg);
										component.set("v.isError",true);
										return;
									}
									else{
										component.set("v.isError",false);
										component.set("v.errorMsg", "");
									}
									
								}
							
							//getCurrency();                 
							
						}                           
					});	
					$A.enqueueAction(action);						
            	//}
         //   }
		//}
		
//	});
//	$A.enqueueAction(OrderValid);
	//** Ends here
	
	//	
}  */ 
})
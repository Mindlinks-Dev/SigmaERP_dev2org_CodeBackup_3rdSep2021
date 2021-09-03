({
    fetchOrderDetails : function(component, event, orderIdFromComponent) 
    {
		 //alert('inside');
        var orderIdFromComponent = component.get("v.recordId");
			//alert('orderIdFromComponentrecid::'+JSON.stringify(component.get("v.recordId")));
			//alert('orderIdFromComponent1::'+component.get(orderIdFromComponent));
		var localvar = component.get("v.isStandardOrder");
	      //alert('localvar::loadOrderName'+localvar);
		if(localvar == true )
		{
           // alert('Inside::>>');
			var action1 = component.get("c.getstandOrderDetailsforcancel");
			action1.setParams
			({
				"OrderId" : orderIdFromComponent
			});
			action1.setCallback(this, function(a1) 
                            {
                                var savedOrderDetails = a1.getReturnValue();
                                //alert('savedOrderDetails>>'+JSON.stringify(savedOrderDetails));
                                var state = a1.getState();
                               component.set("v.OrderstandObject.OrderNumber", savedOrderDetails.OrderNumber); 
								//alert('OrderNumber::'+JSON.stringify(component.get("v.OrderstandObject.OrderNumber")));
                                component.set("v.OrderstandObject.sigmaerpdev2__TotalAmount__c",savedOrderDetails.sigmaerpdev2__TotalAmount__c);
                               // alert('sigmaerpdev2__TotalAmount__c::'+JSON.stringify(component.get("v.OrderstandObject.sigmaerpdev2__TotalAmount__c")));
								component.set("v.OrderstandObject.sigmaerpdev2__Orders_Status__c",savedOrderDetails.sigmaerpdev2__Orders_Status__c);
                               // alert(''+JSON.stringify(component.get("v.OrderstandObject.sigmaerpdev2__Orders_Status__c")));
                            });
				$A.enqueueAction(action1);
		}
		else{
            //alert('insidelse');
			var action1 = component.get("c.getsigmaOrderDetails");
			action1.setParams
			({
				"OrderId" : orderIdFromComponent
			});
			action1.setCallback(this, function(a1) 
                            {
                               // alert(result);
                                var savedOrderDetails = a1.getReturnValue();
                                component.set("v.OrderObject.Name", savedOrderDetails.Name); 
                                component.set("v.OrderObject.sigmaerpdev2__TotalAmount__c",savedOrderDetails.sigmaerpdev2__TotalAmount__c);
                                component.set("v.OrderObject.sigmaerpdev2__Orders_Status__c",savedOrderDetails.sigmaerpdev2__Orders_Status__c);
                                component.set("v.CompleteAmountToRefund",savedOrderDetails.sigmaerpdev2__TotalAmount__c);
                              
                            });
			$A.enqueueAction(action1);
		}
        
    },
    CancelOrderhelper : function(component,event)
    {   
       
        var spinner = component.find('spinner');
        $A.util.addClass(spinner, "slds-show");
        var action1 = component.get("c.CancelSigmaOrder");
        var orderIdFromComponent = component.get("v.Id");
        //alert('orderIdFromComponent::'+orderIdFromComponent);
        var SubTotalAmount = component.get("v.CompleteAmountToRefund");
       // alert('SubTotalAmount::'+JSON.stringify(component.get("v.CompleteAmountToRefund")));
        action1.setParams
        ({
            "OrderId" : orderIdFromComponent,
            "subTotalAmount" : SubTotalAmount
        });
        action1.setCallback(this, function(a1) 
                            {
                                var spinner2 = component.find('spinner');
                                $A.util.removeClass(spinner2, "slds-show");
                                var savedOrderDetails = a1.getReturnValue();
                                var state = a1.getState();
                                //alert('sucess::'+state);
                                //alert('savedOrderDetails::'+savedOrderDetails);
                                if(savedOrderDetails)
                                {
                                    alert("Cancel Order successful ");
                                    location.reload();
                                }
                                else
                                {
                                    alert("Cancel Order Failed");
                                }
                            });
        document.getElementById("Accspinner").style.display = "block";
        $A.enqueueAction(action1);
    }
   
})
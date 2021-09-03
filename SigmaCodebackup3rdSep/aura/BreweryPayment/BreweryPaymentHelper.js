({
	FetchOrderDetails : function(cmp, event, helper) 
    {
		var MainWrapperObject = cmp.get("v.MainWrapperObject");
      //  alert('Inside FetchOrderDetails helper MainWrapperObject>>>'+JSON.stringify(MainWrapperObject)); 
        console.log('MainWrapperObject: ' + JSON.stringify(MainWrapperObject));
        var action = cmp.get("c.getMainWrapper");
        action.setParams({ 
             //MainWrapperParam : JSON.stringify(MainWrapperObject) ,
             orderId : MainWrapperObject.OrderId ,
            registryId: MainWrapperObject.RegistryId
        });
        
        action.setCallback(this, function(response) {
            var state =  response.getState();
            if(cmp.isValid() && state=="SUCCESS")
            {
                //alert('Inside SUCCESS>>>>');
                var StoreResponse = response.getReturnValue();
                cmp.set("v.MainWrapperObject",StoreResponse);
                //alert('After setting successWrapper to MainWrapperObject>>>>'+JSON.stringify(cmp.get("v.MainWrapperObject")));
                console.log('After setting successWrapper MainWrapperObject: ' + JSON.stringify(cmp.get("v.MainWrapperObject")));
                //alert('Create order >>>>'+cmp.get("v.MainWrapperObject").CreateOrder);
                var spinner = cmp.find("mySpinner");
                $A.util.toggleClass(spinner, "slds-hide"); 
                if(StoreResponse.ResistrationStatus == 'success')    
                {
                    //alert('Inside StoreResponse.ResistrationStatus success >>>>');
                    cmp.set("v.showAggrementSection",true);

                }
                else if(StoreResponse.ResistrationStatus == 'Fail')
                {
                    //alert('Inside StoreResponse.ResistrationStatus Fail: >>>>'+StoreResponse.ResponseMessage);
                    cmp.set("v.PaymentStatus",'There is an internal issue with payment process please contact FFTB Admin!'); 
                    cmp.set("v.showFailureSection",true);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: "Error",
                        type: "error",
                        message: StoreResponse.ResponseMessage
                    });
                    toastEvent.fire();
                    return;
                    
                }	
                
            }else
            {
                alert('Inside error callback>>>>');
                alert('response is'+response.getReturnValue());
            }
        });
        $A.enqueueAction(action); 
	},
})
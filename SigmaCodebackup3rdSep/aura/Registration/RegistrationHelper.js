({
     validateEmail : function(elementValue)
    {    
        //alert('Inside Helpers validateEmail>>>>'+elementValue);
        var emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
        var controllerValueKey = eval(elementValue );
        //alert(emailPattern.test(elementValue));
        return emailPattern.test(controllerValueKey); 
    }, 
    
    
    SaveBreweryInfo : function (cmp,event, helper)
    {
       
        var MainWrapperObject = cmp.get("v.MainWrapperObject");
        //alert('Inside SaveBreweryInfo helper MainWrapperObject>>>'+JSON.stringify(MainWrapperObject)); 
        console.log('MainWrapperObject: ' + JSON.stringify(MainWrapperObject));
        var action = cmp.get("c.SaveBreweryInfo");
        action.setParams({ 
            MainWrapperParam : JSON.stringify(MainWrapperObject) ,
        });
        
        action.setCallback(this, function(response) {
            var state =  response.getState();
            if(cmp.isValid() && state=="SUCCESS")
            {
                //alert('Inside SUCCESS>>>>');
                var StoreResponse = response.getReturnValue();
                cmp.set("v.MainWrapperObject",StoreResponse);
                //alert('After setting successWrapper to MainWrapperObject>>>>'+cmp.get("v.MainWrapperObject"));
                console.log('After setting successWrapper MainWrapperObject: ' + JSON.stringify(cmp.get("v.MainWrapperObject")));
                //alert('Create order >>>>'+cmp.get("v.MainWrapperObject").CreateOrder);
                
                var spinner = cmp.find("mySpinner");
                $A.util.toggleClass(spinner, "slds-hide"); 
                
                if(StoreResponse.ResistrationStatus == 'success' && cmp.get("v.MainWrapperObject").CreateOrder == true)  
                {
                    //alert('Inside registrationSuccessfull and  CreateOrder flow true>>>>');
                     //cmp.set("v.registrationSuccessfull",true);
                     cmp.set("v.paymentNotification",true);
                     cmp.set("v.showBasicInfoSection",false);
                     //cmp.set("v.showAddressSection",false);
                }
                else if(StoreResponse.ResistrationStatus == 'success')    
                {
                    //alert('Inside registrationSuccessfull >>>>');
                     cmp.set("v.registrationSuccessfull",true);
                     //cmp.set("v.showPaymentSection",false);
                     //cmp.set("v.showBasicInfoSection",false);
                     //cmp.set("v.showAddressSection",false);
                }
                else if(StoreResponse.ResistrationStatus == 'Fail')
                {
                    //alert('Inside StoreResponse.ResistrationStatus Fail: >>>>'+StoreResponse.ResponseMessage);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: "Error",
                        type: "error",
                        message: StoreResponse.ResponseMessage
                    });
                    toastEvent.fire();
                    return;
        
                }
               
                //alert('StoreResponse>>>'+JSON.stringify(StoreResponse));
                /*if(StoreResponse.CreateOrder)
                {
                    cmp.set("v.registrationSuccessfull",true);
                }
                else
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error",
                        "type" : "error",
                        "message": response.getReturnValue()
                    });
                    toastEvent.fire();
                    return;
                    
                }*/
                
                
                //history.back();
                
            }else
            {
                alert('Inside error callback>>>>');
                alert('response is'+response.getReturnValue());
            }
        });
        $A.enqueueAction(action); 
         
       
    },
})
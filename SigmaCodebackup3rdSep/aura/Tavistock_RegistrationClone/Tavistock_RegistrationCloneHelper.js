({
    saveCustomerInfo : function(component, event, helper) {
        
        
        component.set("v.BookingWrapper.Appointment",component.get("v.SelectedAppointment"));
        component.set("v.BookingWrapper.Amount",component.get("v.Amount"));
        var action = component.get("c.SaveBookingInfo");
        action.setParams({
            BookingWrapperParam: JSON.stringify(component.get("v.BookingWrapper"))
            
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (component.isValid() && state === "SUCCESS"){
                var spinner = component.find("mySpinner");
                $A.util.toggleClass(spinner, "slds-hide");
                var response = result.getReturnValue();
                //alert('response:'+JSON.stringify(response));
                //alert('response.Status:'+response.Status);
                if(response.Status == 'Success')  
                {
                    component.set("v.BookingWrapper",response);
                    component.set("v.showPayment",true);
                    component.set("v.showReg",false);
                    component.set("v.hideback",true);
                    
                    
                    
                }
                else
                {
                    //alert('Inside StoreResponse.ResistrationStatus Fail: >>>>'+response.Response);
                    
                    component.set("v.showReg",true);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: "Error",
                        type: "error",
                        message: response.Response
                    });
                    toastEvent.fire();
                    return;
                    
                }
            }
        });
        $A.enqueueAction(action);
        
    }
})
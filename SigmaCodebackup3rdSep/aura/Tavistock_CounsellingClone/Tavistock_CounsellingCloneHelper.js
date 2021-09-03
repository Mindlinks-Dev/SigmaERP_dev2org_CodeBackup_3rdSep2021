({
	getCourses : function(component, event, helper) {

         var action = component.get("c.FetchCourses");
        /*action.setParams({
            "pageNumber": page,

        });*/
        action.setCallback(this, function(result) {
            var state = result.getState();
            //alert('state:'+state);
            if (component.isValid() && state === "SUCCESS"){
                var spinner = component.find("mySpinner");
                $A.util.toggleClass(spinner, "slds-hide");
                var response = result.getReturnValue();
                
                //alert('response:'+JSON.stringify(response));
                component.set('v.CourseWrapper',response);
                 //alert('CourseWrapper:'+component.get('v.CourseWrapper').length);
                //alert('response.pageSize:'+response.pageSize +' response.page:'+response.page +'response.total:'+response.total);
                component.set('v.page', response.page);
                

            }
        });
        $A.enqueueAction(action);
		
	},
    
    
    saveCustomerInfo : function(component, event, helper) {

       var action = component.get("c.SaveEventInfo");
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
                    var spinner = component.find("mySpinner");
                    $A.util.toggleClass(spinner, "slds-hide");
            		 component.set("v.BookingWrapper",response);
                     component.set("v.successPanel",true);
                     /*component.set("v.showReg",false);
                     component.set("v.hideback",true);*/
            
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
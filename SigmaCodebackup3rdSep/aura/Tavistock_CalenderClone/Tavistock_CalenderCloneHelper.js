({
	getAppointments : function(component, event, helper,page) {
       
        page = page || 1;
         var action = component.get("c.FetchAppointements");
        action.setParams({
            "pageNumber": page,

        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (component.isValid() && state === "SUCCESS"){
                var spinner = component.find("mySpinner");
                $A.util.toggleClass(spinner, "slds-hide");
                var response = result.getReturnValue();
                
                //alert('response:'+JSON.stringify(response));
                component.set('v.MainWrapper',response);
               // alert('AppointmentList:'+component.get('v.MainWrapper.AppointmentList').length);
                //alert('response.pageSize:'+response.pageSize +' response.page:'+response.page +'response.total:'+response.total);
                component.set('v.page', response.page);
                

            }
        });
        $A.enqueueAction(action);
		
	}
})
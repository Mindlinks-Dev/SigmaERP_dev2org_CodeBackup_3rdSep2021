({
    fetchAppointmentData : function(component, event, helper )
    {
        var action = component.get("c.createOffer");   
        action.setParams({ "detailOrder" : component.get("v.workOrderDetails"),
                          "start" : component.get("v.startDate"),
                          "dueDate" : component.get("v.endDate"), 
                         });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state =="SUCCESS") 
            {
                if(response.getReturnValue().status=='Success')
                {
                    console.log('response'+JSON.stringify(response.getReturnValue()));
                    component.set('v.responseData',response.getReturnValue().serviceOffer); 
                    document.getElementById("Accspinner").style.display = 'none';
                    component.set("v.openModalPopUp",true);
                }
                else
                {
                    document.getElementById("Accspinner").style.display = 'none';
                    component.set('v.isError',true);
                    component.set('v.errorMessage',response.getReturnValue());
                }
                
            }
        });
        $A.enqueueAction(action);
    },
    sumbitAppointmentData : function(component, event, helper )
    {
        //alert(JSON.stringify(component.get("v.workOrderDetails")));
        var action = component.get("c.bookOfferAppoinment");         
        action.setParams({ "SelectedOfferDetail" : JSON.stringify(component.get("v.responseData")),
                          "orderDetail" : component.get("v.workOrderDetails"),
                         });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state =="SUCCESS") 
            {
                //alert(state);
                //component.set('v.responseData',response.getReturnValue()); 
                component.set("v.openModalPopUp",false);
                if(response.getReturnValue().status=='Success')
                {
                    document.getElementById("Accspinner").style.display = 'none';
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "type":'success',
                        "message": "BOOKING CONFIRMED."
                    });
                    toastEvent.fire(); 
                    var navLink = component.find("navLink");
                    var pageRef = {
                        type: 'standard__recordPage',
                        attributes: {
                            actionName: 'view',
                            objectApiName: 'ServiceAppointment',
                            recordId : response.getReturnValue().serviceAppointmentId
                        },
                    };
                    navLink.navigate(pageRef, true);
                }
                else
                {
                    document.getElementById("Accspinner").style.display = 'none';
                    component.set('v.isError',true);
                    component.set('v.errorMessage',response.getReturnValue());
                }
                
                
                //component.set("v.openModalPopUp",true);
                
            }
        });
        $A.enqueueAction(action);  
    },
    fetchWorkOrderdDetails : function(component, event, helper )
    {
        var recId = component.get('v.recordId');
        //alert('recId'+recId);
        var action = component.get("c.fetchWorkOrderdDetails");
        action.setParams({ recId : recId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state =="SUCCESS") 
            {
                //alert('response'+JSON.stringify(response.getReturnValue()));
                if(response.getReturnValue().status=='Success'){
                    document.getElementById("Accspinner").style.display = 'none';
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Warning!",
                        "type":'Warning',
                        "message": "Record on hold."
                    });
                    toastEvent.fire();  
                }
				else{
                 helper.fetchAppointmentData(component, event, helper);
            	}                
            }
        })
        $A.enqueueAction(action);  
    }
})
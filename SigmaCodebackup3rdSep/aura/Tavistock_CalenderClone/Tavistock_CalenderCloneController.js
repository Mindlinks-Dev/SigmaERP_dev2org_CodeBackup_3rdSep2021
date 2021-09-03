({
    init: function (component, event, helper,page) {
        page = page || 1;   
        
        //var pageNumber = component.get("v.PageNumber");  
        //var pageSize = component.find("pageSize").get("v.value");
        
          

        	component.set("v.hideback",false);
            component.set(
            "v.LogoutURL",
            'https://ssigma-mvp-dev2-dev-ed-developer-edition.ap17.force.com/tavistockbooking/s/'
            );
        
        
        var spinner = component.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        helper.getAppointments(component, event, helper,page);
    },
    
    
    pageChange: function(component, event, helper) {
        var spinner = component.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        var page = component.get("v.page") || 1;
        var direction = event.getParam("direction");
        page = direction === "previous" ? (page - 1) : (page + 1);
        
        helper.getAppointments(component, event, helper,page);
    },
    
    gotoRegistrationPage: function (component, event, helper) {
        var AppointmentList = component.get("v.MainWrapper.AppointmentList");
        var allow = false;
        var Appointment;
        for(var j = 0 ; j<AppointmentList.length ; j++)
        {
            if(AppointmentList[j].IsSelected ==true)
            {
                allow = true;
                Appointment = AppointmentList[j].Appointment;
                break;
            }
        }
        if(allow)
        {
            component.set("v.SelectedAppointment",Appointment); 
            component.set("v.gotoRegistrationPage",true);
            component.set("v.showAppointmentpage",false);
        }else
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Error",
                type: "error",
                message: "Select an appointment to continue."
            });
            toastEvent.fire();
            return;
        }
        
    },
    backToAppointmentPage: function (component, event, helper) {
        
        component.set("v.gotoRegistrationPage",false);
        component.set("v.showAppointmentpage",true);
    },
    
    handleSelectedAppointment :function (component, event, helper)
    {
        
        var flag = event.getParam('flag');
        var rowIndex = event.getParam('rowIndex');
        var RecordID = event.getParam('RecordID');
        //alert('rowIndex:'+rowIndex +' RecordID:'+RecordID +' flag:'+flag);
        
        var AppointmentList = component.get("v.MainWrapper.AppointmentList");
        component.set("v.SelectedDate",AppointmentList[rowIndex].Appointment.sigmaerpdev2__AppointmentDate__c);
        component.set("v.MainWrapper.duration",AppointmentList[rowIndex].Appointment.sigmaerpdev2__Duration__c +' '+ AppointmentList[rowIndex].Appointment.sigmaerpdev2__Duration_Interval__c);
        component.set("v.MainWrapper.deposit",AppointmentList[rowIndex].Appointment.sigmaerpdev2__Order_amount__c+'.00');
        component.set("v.SelectedDateTime1",AppointmentList[rowIndex].Appointment.sigmaerpdev2__Week_Day__c +' '+AppointmentList[rowIndex].Appointment.sigmaerpdev2__Date_Value__c);
        component.set("v.SelectedDateTime2",AppointmentList[rowIndex].Appointment.sigmaerpdev2__period_of_time__c +' '+AppointmentList[rowIndex].Appointment.sigmaerpdev2__Time__c);
        
        
        //alert('Selected Appointment:'+JSON.stringify(AppointmentList[rowIndex]));
        
        
        for(var j = 0 ; j<AppointmentList.length ; j++)
        {
            //console.log(JSON.stringify(AppointmentList));
            if(AppointmentList[j].IsSelected ==true && j!=rowIndex)
            {
                
                AppointmentList[j].IsSelected = false;
            }
            
        }
        component.set("v.MainWrapper.AppointmentList",AppointmentList);
        
    },
    
    
    
})
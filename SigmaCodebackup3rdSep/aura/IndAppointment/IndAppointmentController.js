({
	selectIndAppoinment : function(component, event, helper) {
        //alert('Index:'+component.get('v.itemIndex') +' RecordId:'+component.get('v.Innerwrapper.Appointment.Id'));

        var cmpEvent = component.getEvent("AppointmentEvent");
        cmpEvent.setParams({
            "rowIndex" : component.get('v.itemIndex') ,
            "flag" : "SelectedAppointment",
            "RecordID" : component.get('v.Innerwrapper.Appointment.Id')
        });
        
        cmpEvent.fire();
        
	}
})
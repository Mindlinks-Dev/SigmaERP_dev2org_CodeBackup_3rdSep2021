({
	employeeSelected : function(component, event, helper) {
		var employee = component.get("v.employee");
        var myEvent = component.getEvent("itemSelected");
        myEvent.setParams({"employee": employee});
        console.log(myEvent);
		myEvent.fire();
	}
})
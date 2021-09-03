({
	clickSchedule : function(component, event, helper) {
		var activeColor = component.find("schedule-row");
        $A.util.toggleClass(activeColor,"background-yellow");
	}
})
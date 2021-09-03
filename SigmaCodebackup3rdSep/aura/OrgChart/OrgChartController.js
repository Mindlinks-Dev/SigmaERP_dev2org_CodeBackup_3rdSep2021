({
	keyChangeHandler : function(component, event, helper) {
		if (event.keyCode !== 13) {
            return;
        }
    	var searchKey = event.target.value;
		component.set("v.currentView", "list");
        component.set("v.employees", []);
        helper.getEmployees(component, searchKey, function(result) {
            component.set("v.employees", result);
        });
	},
    
    itemSelected : function(component, event, helper) {
        var employee = event.getParam("employee");
        component.set("v.currentView", "details");
        component.set("v.employee", null);
        component.set("v.reports", []);
        helper.getEmployeeById(component, employee.Id, function(result) {
	        component.set("v.employee", result);
        });
        helper.getDirectReports(component, employee.Id, function(result) {
	        component.set("v.reports", result);
        });
    }
    
})
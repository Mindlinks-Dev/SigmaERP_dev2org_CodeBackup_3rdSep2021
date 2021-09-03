({
	getEmployees : function(component, searchKey, callback) {
        var action = component.get("c.getEmployees");
		action.setParams({
      		"searchKey": searchKey
    	});
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                callback(a.getReturnValue());
            } else if (state === "INCOMPLETE") {

            } else if (state === "ERROR") {
                var errors = a.getError();
                console.log(errors);
            }
    	});
    	$A.enqueueAction(action);
	},
    
	getEmployeeById : function(component, employeeId, callback) {
        var action = component.get("c.getEmployeeById");
		action.setParams({
      		"employeeId": employeeId
    	});
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                callback(a.getReturnValue());
            } else if (state === "INCOMPLETE") {

            } else if (state === "ERROR") {
                var errors = a.getError();
                console.log(errors);
            }
    	});
    	$A.enqueueAction(action);
	},
    
	getDirectReports : function(component, employeeId, callback) {
        var action = component.get("c.getDirectReports");
		action.setParams({
      		"employeeId": employeeId
    	});
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                callback(a.getReturnValue());
            } else if (state === "INCOMPLETE") {

            } else if (state === "ERROR") {
                var errors = a.getError();
                console.log(errors);
            }
    	});
    	$A.enqueueAction(action);
	}
    
})
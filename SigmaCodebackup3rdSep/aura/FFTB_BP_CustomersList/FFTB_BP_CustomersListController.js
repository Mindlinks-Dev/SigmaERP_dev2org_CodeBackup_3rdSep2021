({
	init: function (component, event, helper) {        
		var spinner = component.find("mySpinner");
		$A.util.toggleClass(spinner, "slds-hide");
		helper.fetchBPCustomers(component, event, helper);
	},
})
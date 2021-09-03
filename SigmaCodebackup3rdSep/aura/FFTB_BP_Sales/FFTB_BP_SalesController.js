({
	init: function (component, event, helper) {        
		var spinner = component.find("mySpinner");
		$A.util.toggleClass(spinner, "slds-hide");
		helper.fetchBPSales(component, event, helper);
	},
    
    SearchSales : function (component, event, helper) {        
		var spinner = component.find("mySpinner");
		$A.util.toggleClass(spinner, "slds-hide");
		helper.fetchBPSales(component, event, helper);
	},
    
    selValue : function (component, event, helper) {
        var sel = component.find("statVal").get("v.value");
        component.set("v.selFilter",sel);
    },
    
    handleEditFlow : function (component, event, helper) {
        var currStatus = event.getParam("currStatus");
        var soId = event.getParam("soId");
        var selAction = event.getParam("selAct");
        if(selAction == 'Mark as Delivered'){
            component.set("v.selFilter", currStatus);
            helper.markAsDel(component, event, helper, soId);
        }else{
            component.set("v.selFilter", currStatus);
        	helper.deleteSalesOrder(component, event, helper, soId);
    	}
    }
    /*loadMoreData: function (cmp, event, helper) {        
		cmp.set('v.loadMoreStatus', 'Loading');
		helper.fetchData(cmp, event, helper)
			.then($A.getCallback(function (data) {
				var currentData = cmp.get('v.PRList');
				var newData = currentData.concat(data);
				cmp.set('v.PRList', newData);
				if (cmp.get('v.PRList').length >= cmp.get('v.totalNumberOfRows')) {
					cmp.set('v.loadMoreStatus', '');
				}else{
					cmp.set('v.loadMoreStatus', 'Load More');
				}				
			}));
	}*/
})
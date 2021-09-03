({
	init: function (component, event, helper) {        
		var spinner = component.find("mySpinner");
		$A.util.toggleClass(spinner, "slds-hide");
		helper.fetchMan(component, event, helper);
	},
    
	NewManu: function (component, event, helper) {
		helper.NewManuH(component, event, helper);
	},
    
	goToHome: function (component, event, helper) {
		helper.goBack(component, event, helper);
	},
    
	openEdit: function (component, event, helper) {                        
		var flag = event.getParam("flag");               
        if (flag == 'edit'){            
            helper.NewManuH(component, event, helper);
        }else if(flag == 'delete'){
            helper.deleteManufactureRunH(component, event, helper);
        }			
	},
    
	loadMoreData: function (cmp, event, helper) {
		//Display a spinner to signal that data is being loaded
		//event.getSource().set("v.isLoading", true);
		//Display "Loading" when more data is being loaded
		cmp.set('v.loadMoreStatus', 'Loading');
		helper.fetchData(cmp, event, helper)
			.then($A.getCallback(function (data) {
				var currentData = cmp.get('v.ManufacList');
				//Appends new data to the end of the table
				var newData = currentData.concat(data);
				cmp.set('v.ManufacList', newData);
				if (cmp.get('v.ManufacList').length >= cmp.get('v.totalNumberOfRows')) {
					cmp.set('v.loadMoreStatus', '');
				}else{
					cmp.set('v.loadMoreStatus', 'Load More');
				}				
			}));
	}
})
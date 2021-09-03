({
    init: function (component, event, helper) {        
		var spinner = component.find("mySpinner");
		$A.util.toggleClass(spinner, "slds-hide");
		helper.fetchPRs(component, event, helper);
	},
    
	NewPR: function (component, event, helper) {
		helper.NewPRH(component, event, helper);
	},
    
    openEdit: function (component, event, helper) {
		var flag = event.getParam("flag");   
        var recID = event.getParam("recID");
        component.set("v.prRecId", recID);
        if (flag == 'edit'){            
            helper.NewPRH(component, event, helper);
        }else if(flag == 'delete'){
            helper.deletePRH(component, event, helper);
        }			
	},
    
    loadMoreData: function (cmp, event, helper) {        
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
	}
})
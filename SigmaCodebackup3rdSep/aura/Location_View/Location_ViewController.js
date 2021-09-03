({
	FetchLoc : function(component, event, helper) {            
		helper.getLocationDetails(component, event, helper);
	},
    loadMoreData: function (cmp, event, helper) {		
		cmp.set('v.loadMoreStatus', 'Loading');
        helper.fetchData(cmp, event, helper);
    },
    goToHome : function(component, event, helper){
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": "/lightning/page/home"
        });
        urlEvent.fire();
    }
})
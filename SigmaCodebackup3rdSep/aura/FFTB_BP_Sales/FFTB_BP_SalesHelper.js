({
	fetchBPSales : function(component, event, helper) {
        var selVal = component.get("v.selFilter");        
		var action = component.get("c.getBPSales");
        /*var counts = cmp.get("v.currentCount");
        action.setParams({
            "limits": cmp.get("v.initialRows"),
            "offsets": counts
        });*/
        action.setParams({
            "selVal": selVal
        });
        action.setCallback(this, function(response) {            
            if(response.getState() == "SUCCESS"){                
                var allValues = response.getReturnValue();                
                component.set("v.bpsList", allValues);
                component.set("v.showTable", true);
            }
            var spinner = component.find("mySpinner");
            $A.util.toggleClass(spinner, "slds-hide");
        });
        $A.enqueueAction(action);
	},
    
    markAsDel : function (component, event, helper, soId){
        var action = component.get("c.markAsDelvStatus");
        action.setParams({ 
            "soId" : soId
        });
        action.setCallback(this, function(response) {
            if(response.getState() == "SUCCESS"){  
                var retVal = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success!",
                    "message": "Sales order status updated successfully!"
                });
                toastEvent.fire();
                helper.fetchBPSales(component, event, helper);
            }
            var spinner = component.find("mySpinner");
            $A.util.toggleClass(spinner, "slds-hide");
        });
        $A.enqueueAction(action);
    },
    
    deleteSalesOrder : function(component, event, helper, soId){
        var action = component.get("c.deleteSalesOrder");
        action.setParams({ 
            "soId" : soId
        });
        action.setCallback(this, function(response) {
            if(response.getState() == "SUCCESS"){  
                var retVal = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success!",
                    "message": "Sales order deleted successfully!"
                });
                toastEvent.fire();
                helper.fetchBPSales(component, event, helper);
            }
            var spinner = component.find("mySpinner");
            $A.util.toggleClass(spinner, "slds-hide");
        });
        $A.enqueueAction(action);
    }
    /*fetchData: function (component, event, helper) {        
        return new Promise($A.getCallback(function (resolve, reject) {
            var currentDatatemp = component.get('c.getBPSales');
            var counts = component.get("v.currentCount");
            currentDatatemp.setParams({
                "limits": component.get("v.initialRows"),
                "offsets": counts
            });
            currentDatatemp.setCallback(this, function (a) {                                
                if(a.getReturnValue().totalRows != null){
                	component.set("v.totalNumberOfRows", a.getReturnValue().totalRows);    
                }
                var countstemps = component.get("v.currentCount");
                countstemps = countstemps + component.get("v.initialRows");
                component.set("v.currentCount", countstemps);
                resolve(a.getReturnValue());
            });
            $A.enqueueAction(currentDatatemp);
        }));
    },*/
})
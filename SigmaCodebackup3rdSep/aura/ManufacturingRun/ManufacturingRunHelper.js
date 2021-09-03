({
    fetchMan : function(cmp, event, helper) {
        var action = cmp.get('c.fetchManufacturingRun');
        var counts = cmp.get("v.currentCount");
        action.setParams({
            "limits": cmp.get("v.initialRows"),
            "offsets": counts
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set('v.ManufacList', response.getReturnValue().manfList);                               
                if(response.getReturnValue().totalRows != null){
                	cmp.set("v.totalNumberOfRows", response.getReturnValue().totalRows);    
                }               
                cmp.set("v.autoAllocFlag", response.getReturnValue().autoAllocate);               
                if (cmp.get('v.ManufacList').length >= cmp.get('v.totalNumberOfRows')) {
                    cmp.set('v.loadMoreStatus', '');
                }
                var countstemps = cmp.get("v.currentCount");
                countstemps = countstemps + cmp.get("v.initialRows");
                cmp.set("v.currentCount", countstemps);
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
            var spinner = cmp.find("mySpinner");
		    $A.util.toggleClass(spinner, "slds-hide");
        }));
        $A.enqueueAction(action);
    },
    
    fetchData: function (component, event, helper) {        
        return new Promise($A.getCallback(function (resolve, reject) {
            var currentDatatemp = component.get('c.fetchManufacturingRun');
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
                resolve(a.getReturnValue().manfList);
            });
            $A.enqueueAction(currentDatatemp);
        }));
    },
    
    NewManuH : function(component, event, helper) {
        /*var action1 = component.get("c.getCompanyName");        
        action1.setCallback(this, function (response1) {
			var response = response1.getReturnValue();            
			component.set("v.compName", response);
		});
		$A.enqueueAction(action1);*/
      
        var newMan = component.find("newMan");
        var ManList = component.find("ManList");
        $A.util.removeClass(newMan, "slds-hide");
        $A.util.addClass(ManList, "slds-hide");
		component.set("v.hideMRHeader", true);        
	},
    
    goBack : function(component, event, helper) {
        var newMan = component.find("newMan");
        var ManList = component.find("ManList");
        $A.util.addClass(newMan, "slds-hide");
        $A.util.removeClass(ManList, "slds-hide");
		component.set("v.hideMRHeader", false);                
	},
    
    deleteManufactureRunH : function(component, event, helper){        
        var manfId = event.getParam("recID");          
        var action = component.get("c.deleteManufacturingRun");
        action.setParams({
            "manRunId" : manfId
        });
        action.setCallback(this, function (response1) {            
            var state = response1.getState();            
			var response = response1.getReturnValue();            			
            if(response == 'SUCCESS'){
                $A.get('e.force:refreshView').fire();
                return;
            }else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"error",
                    "title": "Error!",
                    "message": "Error during deletion of Manufacturing Run."
                });
                toastEvent.fire(); 
                return;
            }
		});
        $A.enqueueAction(action);
    }    
})
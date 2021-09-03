({
    fetchPRs : function(cmp, event, helper) {
        var action = cmp.get('c.listPRDetails');
        var counts = cmp.get("v.currentCount");
        action.setParams({
            "limits": cmp.get("v.initialRows"),
            "offsets": counts
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set('v.PRList', response.getReturnValue().prList);
                cmp.set("v.profName",response.getReturnValue().profileName);
                if(response.getReturnValue().totalRows != null){
                	cmp.set("v.totalNumberOfRows", response.getReturnValue().totalRows);    
                }          
                if (cmp.get('v.PRList').length >= cmp.get('v.totalNumberOfRows')) {
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
            var currentDatatemp = component.get('c.listPRDetails');
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
                resolve(a.getReturnValue().prList);
            });
            $A.enqueueAction(currentDatatemp);
        }));
    },
    
    
	NewPRH : function(component, event, helper) {
        var newMan = component.find("newPR");
        var ManList = component.find("PRList");
        $A.util.removeClass(newMan, "slds-hide");
        $A.util.addClass(ManList, "slds-hide");
        component.set("v.hidePRHeader", true);  
	},
    
    deletePRH : function(component, event, helper){
        var action = component.get("c.deletePR");
        action.setParams({ 
            "recID" : component.get("v.prRecId")
        });
        action.setCallback(this, function(response) {
            if(response.getState() == "SUCCESS"){
                var returnMsg = response.getReturnValue();
                if(returnMsg == 'success'){
                	var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "success",
                        "title": "Success!",
                        "message": "Product request record has been deleted successfully."
                    });
                    toastEvent.fire(); 
                    var evt = $A.get("e.force:navigateToComponent");
                    evt.setParams({
                        componentDef : "c:PRMain"
                    });
                    evt.fire();
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "error",
                        "title": "Error!",
                        "message": returnMsg
                    });
                    toastEvent.fire(); 
                }
            }    
        });
        $A.enqueueAction(action); 
    } 
    
})
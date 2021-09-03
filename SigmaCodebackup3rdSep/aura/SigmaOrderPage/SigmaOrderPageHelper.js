({
	getSigmaOrderList : function(comp, event, helper,page) 
    {
        page = page || 1;
        var action = comp.get("c.fetchSigmaOrderList");
        action.setParams({ pageNumber : page });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var accs = response.getReturnValue();
                
                comp.set('v.total', accs.totalSigma);
                comp.set('v.page', accs.pageSigma);
                comp.set('v.pages', Math.ceil(accs.totalSigma/accs.pageSizeSigma));
                comp.set("v.sigmaList",accs.sigmaList);
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        
        $A.enqueueAction(action);
    }
})
({
	getPropList : function(comp, event, helper,page) 
    {
        page = page || 1;
        var action = comp.get("c.fetchProposalList");
        action.setParams({ pageNumberProposal : page });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var accs = response.getReturnValue();
                
                comp.set('v.total', accs.totalProp);
                comp.set('v.page', accs.pageProp);
                comp.set('v.pages', Math.ceil(accs.totalProp/accs.pageSizeProp));
                comp.set("v.PropList",accs.PropList);
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
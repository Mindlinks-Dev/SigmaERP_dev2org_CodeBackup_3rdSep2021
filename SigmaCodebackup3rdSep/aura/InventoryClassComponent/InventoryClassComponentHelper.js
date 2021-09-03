({
    getPackagesList : function(comp, event, helper,page) 
    {
        page = page || 1;
        var action = comp.get("c.fetchStappOrderList");
        action.setParams({ pageNumber : page });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var accs = response.getReturnValue();
                
                comp.set('v.total', accs.total);
                comp.set('v.page', accs.page);
                comp.set('v.pages', Math.ceil(accs.total/accs.pageSize));
                comp.set("v.soList",accs.soList);
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
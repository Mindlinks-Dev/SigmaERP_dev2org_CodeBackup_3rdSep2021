({
	getOrderList : function(comp, event, helper,page) 
    {
        page = page || 1;
        var action = comp.get("c.fetchOrderList");
        action.setParams({ pageNumberOrder : page });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var accs = response.getReturnValue();
                
                comp.set('v.total', accs.totalOrder);
                comp.set('v.page', accs.pageOrder);
                comp.set('v.pages', Math.ceil(accs.totalOrder/accs.pageSizeOrder));
                comp.set("v.OrderList",accs.OrderList);
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
({
    fetchSO : function(component, event, helper,page) 
    {
        page = page || 1;
        var action = component.get("c.FetchSalesOrders");
         action.setParams({
            PageNumber : component.get("v.page")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log("responce "+JSON.stringify(response.getReturnValue()));
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                if (res) {
                    component.set('v.SOresponse', res.SalesViewList);
                    component.set('v.total', res.totalRecords);
                    component.set('v.page',	res.page);
                    component.set('v.pages', Math.ceil(res.totalRecords/res.pageSize));
                }
                else
                {
                    component.set('v.SOresponse', '');
                    component.set('v.total', 0);
                    component.set('v.page',	1);
                    component.set('v.pages', 1);
                }
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
            var spinner = component.find('spinner');
            $A.util.toggleClass(spinner, "slds-hide");   
        });
        
        $A.enqueueAction(action);
    },
})
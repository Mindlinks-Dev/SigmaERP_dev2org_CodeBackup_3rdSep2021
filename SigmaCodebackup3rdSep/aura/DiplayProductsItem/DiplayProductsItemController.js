({
    myAction : function(component, event, helper) 
    {
        //alert('recordId in Parent>>'+component.get("v.recordId"));
        var ProList = component.get("c.getproductlist");
        ProList.setParams
        ({
            recordId: component.get("v.recordId")
        });
        
       
        ProList.setCallback(this, function(data) 
                            {
                                var status=data.getState();
                                //alert("status"+status);
                                component.set("v.completeWrap", data.getReturnValue());                              
                                //alert(component.get("v.completeWrap"));
                                component.set("v.Product", data.getReturnValue());
                            });
        $A.enqueueAction(ProList);
    },
    Shipcmp:function(component, event, helper) {
        //alert("View Cart");
        component.set("v.parentcmp",false);
        component.set("v.isShipcmp",true);
        component.set("v.hideproduct",false);
    },
    saveproddata :function(component, event, helper) {
        var index = event.currentTarget;
        var indexval = index.dataset.record;
        helper.saveToCart(component, event, helper,indexval);
    },
    quickviewcmp :function(component, event, helper)
    { 
 
        var object = component.get('v.completeWrap.productList')[event.currentTarget.name];
        component.set("v.recordId",object.Id); 
        component.set("v.quickviewedProduct",component.get('v.completeWrap.productList')[event.currentTarget.name]); 
        component.set("v.quickview",true);
    },
    closeNotification :function(component, event, helper)
    { 
		component.set("v.closeNotification",false);    	
    }
})
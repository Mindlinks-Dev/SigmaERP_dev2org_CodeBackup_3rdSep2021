({
	doInit : function(component, event, helper) {
        //code added to restict Payement (custom button) access for specific users
        //alert(component.get("v.pageReference"));
        //alert('recordIs'+component.get("v.recordId"));
       var sURL =location.href;
		var userId = sURL.split('Id=')[1];
		component.set("v.recordId",userId);
 	//alert(userId);
        
        var action = component.get("c.requestdetails");
        action.setParams({ 
            "SAId" : component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state==="SUCCESS") {
                var tranfers = response.getReturnValue();
                component.set("v.productTransfer",tranfers);
               // alert('inns'+component.set("v.productTransfer",tranfers));
                console.log('data===='+JSON.stringify(component.get("v.productTransfer")));                
            }
        });
          $A.enqueueAction(action); 
    }
})
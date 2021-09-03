({
	doInit : function(component, event, helper) {
        //alert('red'+component.get('v.recordId'));
        var action = component.get("c.FetchOrderData");        
        action.setParams({
            "OrderId" :component.get('v.recordId'),
        });
		 action.setCallback(this, function(response){
             var state = response.getState();  
          if(state == "SUCCESS"){
          var orderdata = response.getReturnValue();
           component.set('v.OrderData',orderdata);
              
          }
         
         });
        $A.enqueueAction(action);
	}
})
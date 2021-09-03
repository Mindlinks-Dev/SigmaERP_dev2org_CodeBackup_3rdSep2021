({
	RecordDetails : function(component, event, helper) {
      //  alert('js called');
		var action = component.get("c.fetchOrderLine"); 
        
        action.setCallback(this, function(response) 
        {  
           // alert(response.getState());
            if (response.getState() === "SUCCESS") 
            {
			  //var prod= response.getReturnValue();
                //alert('----'+JSON.stringify(response.getReturnValue()));
            	component.set('v.manageView',response.getReturnValue());
                
                //alert('success');
            } 
            else if (response.getState() === "ERROR") 
            {
            	console.log(a.getError());       
            }           
        });
        $A.enqueueAction(action);
	},
    
     gotoList : function(component) {
         window.location.reload();
       
     /*   var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:InventoryClassComponent",
            componentAttributes: {                
            }
        });
        evt.fire();
        */
         
    }
    
    

    
   
  
    
})
({
	myAction : function (component, event, helper) {
       
        var recId = component.get("v.recordId");
       
        
         alert('rec>>'+recId);
        if(recId!=null && recId !=''){ 
            var action = component.get("c.cancelWO");
        action.setParams({ recId : recId
                         
                         });
            action.setCallback(this, function(response) {
            var state = response.getState();
             alert('state'+ state);
            if (state =="SUCCESS") 
            {
                var result = response.getReturnValue();
               alert('re>>'+JSON.stringify(result));
                
                if(result.sigmaerpdev2__Status__c!='Cancelled'){
                  
                    component.set("v.showSuccess", true);
                    component.set('v.status',result.sigmaerpdev2__Status__c);
                  // alert('v.status'+component.get('v.status'));
                    
                }
                else{
                   
               var toastEvent = $A.get("e.force:showToast");
												toastEvent.setParams({
													"title": "Error!",
													"type" : "error",
												    "message": "Work order cancelled successfully",
												});
												toastEvent.fire();
                  						 window.location.reload();
                   
                    							
                								
}
                
            }
        });
        $A.enqueueAction(action);
             
        }
    
    },
    
   /*  cancelreason : function(cmp,event,helper)
    {
       
      
        var reason = cmp.find("cancelreason").get('v.value');
         	
    
    
    
       
        
        
    },*/
    reason:function(component, event, helper){
       
        
       var rsn= component.find("reasonPicklist").get("v.value");
        
       // alert('rsn>'+rsn);
       // var workOrderId = component.get("v.recordId");
          var recId = component.get("v.recordId");
         var action = component.get("c.cancelWO");
        action.setParams({ "rsn" : rsn,"recId" : recId});
            action.setCallback(this, function(response) {
            var state = response.getState();
             //alert(state);
            if (state =="SUCCESS") 
            {                
            }
        });
        $A.enqueueAction(action);
    },
    closeWindow : function(component, event, helper) {
		$A.get("e.force:closeQuickAction").fire();
	},
    handleComponentEvent :function(component, event, helper){
        var message = event.getParam("slotBusy");
        //alert(message);
        component.set("v.slotBusy",message);
    }
    
})
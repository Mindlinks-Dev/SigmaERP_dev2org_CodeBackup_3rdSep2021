({
	
    
    doInit :function(component, event, helper){
         var workOrderId = component.get("v.recordId");
         var action = component.get("c.GetresonPick");
        action.setParams({"workOrderId" : workOrderId});
            action.setCallback(this, function(response) {
            var state = response.getState();
             //alert(state);
            if (state =="SUCCESS") 
            {                
                var worder=response.getReturnValue();
                
                var toastEvent = $A.get("e.force:showToast");
                 if(worder.sigmaerpdev2__Status__c=='Rejected'){
                   toastEvent.setParams({
                        title: "Error",
                        type: "error",
                        message: "The Work order is already rejected",
                        mode : "sticky"
                    });
                    toastEvent.fire();
                      $A.get("e.force:closeQuickAction").fire();
                     window.location.reload();
                     
                 }
                
            }
        });
        $A.enqueueAction(action);
    },
    
    
    
    
    
    
    
    confirm : function(component, event, helper){
        var action1 = component.get("c.WorkOrderRejectNew"); 
        var workOrderId = component.get("v.recordId");
        var device = $A.get("$Browser.formFactor"); 
        console.log(workOrderId);
        action1.setParams({
            "workOrderId" : workOrderId,
        }    
        );
    	action1.setCallback(this , function(response){
            if(response.getState() === "SUCCESS"){
            	var toastEvent = $A.get("e.force:showToast");
                console.log(response.getReturnValue());
                if(response.getReturnValue() == "success" || response.getReturnValue() == "Success"){
                    console.log('success');
                    toastEvent.setParams({
                        title: "Success",
                        type: "success",
                        message: "Work Order Rejected Successfully!"
                    });
                       if(device=="DESKTOP")
                  {
                      //alert('innnnn');
                      window.location.reload();
                  $A.get("e.force:closeQuickAction").fire();
                  }
                    else if(device=="PHONE"){
                        //alert('innnnn mobile');
                         var navEvt = $A.get("e.force:navigateToSObject");
   navEvt.setParams({
     "recordId": workOrderId,
     "slideDevName": "related"
   });
   navEvt.fire();
                    
                   }
                 
                } else if(response.getReturnValue() == "Send_Back_Reason__c Field Not Updated"){
                   toastEvent.setParams({
                        title: "Error",
                        type: "error",
                        message: "Please enter the Send Back reason.",
                        mode : "sticky"
                    });
                    console.log(response.getReturnValue()); 
                }
                else{
                    toastEvent.setParams({
                        title: "Error",
                        type: "error",
                        message: response.getReturnValue(),
                        mode : "sticky"
                    });
                    console.log(response.getReturnValue());
                }
                toastEvent.fire();
			}
        });
        console.log(workOrderId);
        $A.enqueueAction(action1);
    },closeWindow : function(component, event, helper) {
		$A.get("e.force:closeQuickAction").fire();
	},
    
    
    reason:function(component, event, helper){
       
        
       var rsn= component.find("reasonPicklist").get("v.value");
        
       //alert('rsn>'+rsn);
        
         var workOrderId = component.get("v.recordId");
         var action = component.get("c.SendBackreason");
        action.setParams({ "rsn" : rsn,"workOrderId" : workOrderId});
            action.setCallback(this, function(response) {
            var state = response.getState();
             //alert(state);
            if (state =="SUCCESS") 
            {                
            }
        });
        $A.enqueueAction(action);
    },
    closeModal: function(component, event, helper) {
      window.location.reload(); 
      component.set("v.isOpen", false);
   }   
    
})
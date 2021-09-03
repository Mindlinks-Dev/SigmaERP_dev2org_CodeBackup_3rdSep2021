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
                     window.location.reload();
                      $A.get("e.force:closeQuickAction").fire();
                     //window.location.reload();
                     
                 }
                 if(worder.sigmaerpdev2__Status__c=='Cancelled'){
                   toastEvent.setParams({
                        title: "Error",
                        type: "error",
                        message: "The Work order is already Cancelled",
                       duration:' 20000',
                        mode : "sticky"
                    });
                    toastEvent.fire();
                    window.location.reload();
                    $A.get("e.force:closeQuickAction").fire();
                     //window.location.reload();
                     
                 }
                
            }
        });
        $A.enqueueAction(action);
    },
    
    
    
    
    
    accept : function(component, event, helper){
        var action1 = component.get("c.WorkOrderAccept"); 
        //alert('action1'+action1);
        var device = $A.get("$Browser.formFactor"); 
       // alert('ibbbbb'+device);
        var workOrderId = component.get("v.recordId");
       // alert('workOrderId'+workOrderId);
        console.log(workOrderId);
        action1.setParams({
            "workOrderId" : workOrderId,
        }    
        );
    	action1.setCallback(this , function(response){
            if(response.getState() === "SUCCESS"){
               //alert('response.getState()'+response.getState());
            	var toastEvent = $A.get("e.force:showToast");
                console.log(response.getReturnValue());
                     //alert('response.getReturnValue()'+response.getReturnValue());
                if(response.getReturnValue() == "success" || response.getReturnValue() == "Success"){
                console.log('success');
                    toastEvent.setParams({
                        title: "Success",
                        type: "success",
                        message: "Work Order Accepted Successfully!"
                    });
                  //alert('inn'+workOrderId);
                  if(device=="DESKTOP")
                  {
                     // alert('innnnn');
                      window.location.reload();
                  $A.get("e.force:closeQuickAction").fire();
                  }
                    else if(device=="PHONE"){
                       // alert('innnnn mobile');
                         var navEvt = $A.get("e.force:navigateToSObject");
   navEvt.setParams({
     "recordId": workOrderId,
     "slideDevName": "related"
   });
   navEvt.fire();
                    
                   }
          
                }else
                    if(response.getReturnValue() == null){
                       if(device=="DESKTOP")
                  {
                       // alert('device'+device);
                     alert('WorkOrder Cannot be Accepted');
                      window.location.reload();
                  $A.get("e.force:closeQuickAction").fire();
                  }
                    else if(device=="PHONE"){
                       // alert('device'+device);
                       alert('WorkOrder Cannot be Accepted');
                         var navEvt = $A.get("e.force:navigateToSObject");
   navEvt.setParams({
     "recordId": workOrderId,
     "slideDevName": "related"
   });
   navEvt.fire();
                    
                   }    

                   }else{
                   //alert('innnd');
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
    
    closeModal: function(component, event, helper) {
      window.location.reload(); 
      component.set("v.isOpen", false);
   }   
    
})
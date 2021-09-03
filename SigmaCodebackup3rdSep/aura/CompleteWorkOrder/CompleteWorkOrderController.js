({
    woliStatus: function(component, event, helper){
        
        var action = component.get("c.workOrderLineItemStatus");        
        var workOrderId = component.get("v.recordId");
        console.log(workOrderId);
        action.setParams({
            "workOrderId" : workOrderId,
        }    
                        );
        action.setCallback(this , function(response){
            if(response.getState() === "SUCCESS"){
                //component.set('v.workorderstatus',response.getReturnValue());
                if(response.getReturnValue() == "success"){
                    component.set('v.isOpen',true);
                    component.set('v.isComplete',false);
                }
                else{
                    component.set('v.isOpen',false);
                    component.set('v.isComplete',true);
                }
            }else{
                
                console.log('Error');
            }
        });
        console.log(workOrderId);
        $A.enqueueAction(action);
    },
    init : function(component, event, helper){
        
      var isMobile = /Android/i.test(navigator.userAgent);
         //var device = $A.get("$Browser.formFactor"); 
       // alert('innnn'+isMobile);
        var action1 = component.get("c.WorkOrderCompleteNew");        
        var workOrderId = component.get("v.recordId");
        console.log(workOrderId);
        action1.setParams({
            "workOrderId" : workOrderId,
            "IsAndroid":isMobile,   
        });
        action1.setCallback(this , function(response){
            if(response.getState() === "SUCCESS"){
                var toastEvent = $A.get("e.force:showToast");
                console.log(response.getReturnValue());
                component.set('v.workorderstatus',response.getReturnValue());
                if(response.getReturnValue() == "success" || response.getReturnValue() == "Success"){
                    component.set('v.isOpen',true);
                    component.set('v.isComplete',false);
                    console.log('success');
                    toastEvent.setParams({
                        title: "Success",
                        type: "success",
                        message: "Work Order Completed Successfully!"
                    });
                  
                    if(isMobile==true){
                        //alert('truessss');
                         var navEvt = $A.get("e.force:navigateToSObject");
   navEvt.setParams({
     "recordId": workOrderId,
     "slideDevName": "related"
   });
   navEvt.fire();
                        // window.location.reload();
                   // $A.get("e.force:closeQuickAction").fire();
                    
                      //  alert('innt');
                   }
                        
                    else{
                 window.location.reload();
                    $A.get("e.force:closeQuickAction").fire();
                    
                  //alert('innnns');
                }
                    
                }
                else if(response.getReturnValue() == "failure"){
                    component.set('v.isOpen',false);
                    component.set('v.isComplete',true);
                    /*toastEvent.setParams({
                        title: "",
                        type: "error",
                        message:"Please delete the WorkOrderLineItem records that are unused",
                        mode : "sticky"
                    });*/
                    console.log(response.getReturnValue());
                }
                    else if(response.getReturnValue() == "Reason for another visit empty"){
                            component.set('v.isOpen',false);
                			component.set('v.isComplete',true);
                			toastEvent.setParams({
                        title: "Error",
                        type: "error",
                        message:"Picklist Field - 'Reason for another Visit' is empty",
                        mode : "sticky"
                    });
                
            }
            else{
                //component.set('v.isComplete',false);
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
        //  window.close();
        component.set("v.isComplete", false);
    },OpenPopup: function(component, event, helper){
        component.set("v.isOpen", true); 
    }
})
({
  
 save : function(component, event, helper) {
 		
     	var actData =component.get("v.accObject");
     	var actDataMap =component.get("v.actmap");
     	var testingdata = JSON.stringify(actData);
        var action = component.get("c.saveBPUsers");
      
        action.setParams({
            "act":JSON.stringify(actDataMap)
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state == "SUCCESS") {
                			var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "type":"success",
                                "title": "Success!",
                                "message": "Brewery record Updated successfully!"
                            });
                            toastEvent.fire();
                            component.find("popupmodal").notifyClose();
                            //$A.get('e.force:refreshView').fire();
                        }
                        else if (state === "INCOMPLETE") {
                        }
                        else if (state == "ERROR") {
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
 },
  close:function(component){
      component.find("popupmodal").notifyClose();
    } 
})
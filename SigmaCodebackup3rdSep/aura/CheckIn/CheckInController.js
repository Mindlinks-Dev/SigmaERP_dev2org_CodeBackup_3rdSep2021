({
	init : function(component, event, helper) {
        component.set('v.disableProceed',true);
        
        // get current location's lat,log
        if (navigator.geolocation) {
            debugger;
            navigator.geolocation.getCurrentPosition(function(position) {
                var latit = position.coords.latitude;
                var longit = position.coords.longitude;
                component.set("v.latitude",latit);
                component.set("v.longitude",longit);
                //alert('latit'+latit);
                //alert('longit'+longit);
        var currentWOId=component.get("v.recordId");
         var action = component.get("c.updatecurentworkorderlocation");
            action.setParams({
                "WOrecordId":currentWOId,
                "Lat":component.get('v.latitude'),
                "Log":component.get('v.longitude'),
                "checkListDetails" : component.get('v.finalValues')
            });
            action.setCallback(this, function(a) {
                var result = a.getReturnValue().split(' ');
                var state = a.getState();
                var toastEvent = $A.get("e.force:showToast");
                if (state === "SUCCESS") {
                	if(result[0]=='success'){
                            
                            component.set("v.isModalOpen", true);
                            component.set('v.disableProceed',false);
                            component.set('v.myRecordId',result[1]);
                            //window.location.reload();  
                        }
                        else{
                            toastEvent.setParams({
                                title: "Error",
                                type: "error",
                                message: "Check-In not Successful, as there are pending items in the Checklist.",
                                mode : "sticky"
                            });
                            toastEvent.fire();
                            component.set('v.disableProceed',false);
                        }   
                }else if (state === "INCOMPLETE") {
                    component.set('v.disableProceed',false);
                // do something
            }
                else if (state === "ERROR") {
                    
                }
               
            });
            $A.enqueueAction(action);
                    });
        }
        /*for(var i=0;i<2799999999;i++){
            
        }
        window.location.reload();*/
        //$A.get("e.force:closeQuickAction").fire();
		
	},
    
    doInit : function(component, event, helper) {
        helper.getWOCheckListRecords(component,event);
    },
    
    handleUploadFinished: function (cmp, event) {
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
        //alert("Files uploaded : " + uploadedFiles.length);
    },
    
    closeModel : function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isModalOpen", false);
        window.location.reload();
        $A.get("e.force:closeQuickAction").fire();
    },
    
    submitDetails : function(component, event, helper) {
        // Set isModalOpen attribute to false
        //Add your code to call apex method or do some processing
       // alert('innnnn');
       var device = $A.get("$Browser.formFactor"); 
      var currentWOId=component.get("v.recordId");
        component.set("v.isModalOpen", false);
        if(device=="DESKTOP")
         {
        window.location.reload();
        $A.get("e.force:closeQuickAction").fire();
         }
        else if(device=="PHONE"){
                        //alert('innnnn mobile');
                         var navEvt = $A.get("e.force:navigateToSObject");
   navEvt.setParams({
     "recordId": currentWOId,
     "slideDevName": "related"
   });
   navEvt.fire();
                    
                   }
    },

    closeWindow : function(component, event, helper) {
		$A.get("e.force:closeQuickAction").fire();
	},
})
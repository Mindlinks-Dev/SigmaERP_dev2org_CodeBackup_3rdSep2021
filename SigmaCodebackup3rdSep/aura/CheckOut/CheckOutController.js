({
	init : function(component, event, helper) {
        debugger;
        event.getSource().set("v.disabled", true);
        // get current location's lat,log
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function(position) {
                var latit = position.coords.latitude;
                var longit = position.coords.longitude;
                component.set("v.latitude",latit);
                component.set("v.longitude",longit);
                //alert('latit'+latit);
                //alert('longit'+longit);
        var currentWOId=component.get("v.recordId");
         var action = component.get("c.CheckOut");
            action.setParams({
                "WOrecordId":currentWOId,
                "Lat":component.get('v.latitude'),
                "Log":component.get('v.longitude')
            });
            action.setCallback(this, function(a) {
                var result = a.getReturnValue().split(' ');
                var state = a.getState();
                if (state === "SUCCESS") {
                    if(result[0]=='success'){
                        component.set("v.isModalOpen", true);
                        component.set('v.myRecordId',result[1]);
                    }
                     
                }else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    
                }
               
            });
            $A.enqueueAction(action);
                    },function(){alert('Error');},{maximumAge:0, timeout:9000, enableHighAccuracy:true});
        }
        
       /* for(var i=0;i<2799999999;i++){
            
        }*/
        
        $A.get('e.force:refreshView').fire();
        
        
		
	},
    
    closeModel : function(component, event, helper) {
      // Set isModalOpen attribute to false  
      
      component.set("v.isModalOpen", false);
        window.location.reload();
        $A.get("e.force:closeQuickAction").fire();
   },
  
   submitDetails : function(component, event, helper) {   
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
    handleUploadFinished: function (cmp, event) {
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
        //alert("Files uploaded : " + uploadedFiles.length);
    },
})
({
	handleMenuSelect : function(component, event, helper) {
        var manufId = component.get("v.Manufac.Id");        
        var status = component.get("v.Manufac.sigmaerpdev2__Status__c");
		var selectedMenuItemValue = event.getParam("value");
		
        var ManufactureApplicationEvent = $A.get("e.c:ManufactureApplicationEvent");
        
        if(selectedMenuItemValue == 'Edit'){        	
            if(status == 'Cancelled'){            
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"error",
                    "title": "Warning!",
                    "message": "Cancelled Manufacturing Runs cannot be edited."
                });
                toastEvent.fire(); 
                return;
            }            
            ManufactureApplicationEvent.setParams({
                "recID" : manufId, "isEdit":true, "flag":"edit" });
            ManufactureApplicationEvent.fire();   
        }else if(selectedMenuItemValue == 'Delete'){
            var manfRunName = component.get("v.Manufac.sigmaerpdev2__Manufacturing_Name__c");
        	 $.confirm({
                title: 'Are you sure you want to delete manufacturing run "'+manfRunName+'" ?',
                content: '',                
                type: 'orange',                
                typeAnimated: true,
                animation: 'scale',
                closeAnimation: 'scale',
                animationBounce: 2,
                buttons: {
                    Yes: {
                        text: 'Yes',
                        btnClass: 'btn-green',
                        action: function () {
                            ManufactureApplicationEvent.setParams({
                                "recID" : manufId,"isEdit":true,"flag":"delete" });
                            ManufactureApplicationEvent.fire();                              
                        }
                    },
                    No: function () {
                    },
                }
            });		    
        }
	},
    
    viewDetails : function(component, event, helper){        
        var manufId = component.get("v.Manufac.Id");  
        var ManufactureApplicationEvent = $A.get("e.c:ManufactureApplicationEvent"); 		
        ManufactureApplicationEvent.setParams({
                "recID":manufId, "isEdit":true, "flag":"edit"});        
        ManufactureApplicationEvent.fire();         
    },
    RedirectGantt: function (component, event, helper) {				
        var manRunID = component.get("v.Manufac.Id");                  
		window.open('/apex/MR_GanttChart?Id='+manRunID);         
	}
})
({
	handleMenuSelect : function(component, event, helper) {
        var prId = component.get("v.prDetails.Id");
		var selectedMenuItemValue = event.getParam("value");
        var ManufactureApplicationEvent = $A.get("e.c:ManufactureApplicationEvent");
        if(selectedMenuItemValue == 'Edit'){
            ManufactureApplicationEvent.setParams({
                "recID" : prId, "isEdit":true, "flag":"edit"});
            ManufactureApplicationEvent.fire();  
        }else if(selectedMenuItemValue == 'Delete'){
            var name = component.get("v.prDetails.Name");
        	 $.confirm({
                title: 'Are you sure you want to delete Product Request "'+name+'" ?',
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
                                "recID" : prId,"isEdit":true,"flag":"delete" });
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
        /*var temp = component.get("v.prDetails.Id");
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": temp,
            "slideDevName": "related"
        });
        navEvt.fire();*/
        var sigmalist =  component.get("v.prDetails.Id");
        window.open("/"+sigmalist);
    },
})
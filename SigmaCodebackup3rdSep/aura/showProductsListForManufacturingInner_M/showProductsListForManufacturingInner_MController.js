({
	validateQuantity : function(component, event, helper) {        
		var availQuantity = component.get("v.innerList.ilpAvailQuantity");                         
        var selQuantity = component.get("v.innerList.selQuantity");         
        if(selQuantity != ''){
        	if(selQuantity < 0 || isNaN(selQuantity)){
                var msg = '';
                if(isNaN(selQuantity)){
                    msg = 'Invalid value for Picked quantity.';
                }else if(selQuantity < 0){
                    msg = 'Quantity value must be greater than 0.';
                }                	          
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"error",
                    "title": "Warning!",
                    "message": msg
                });
                toastEvent.fire(); 
                component.set("v.innerList.selQuantity","");
                return;                 
        	}    
        }                
        if(selQuantity > availQuantity){            
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"error",
                "title": "Warning!",
                "message": 'Quantity value must be less than or equal to : '+availQuantity
            });
            toastEvent.fire();            
            return;
        }
	}    
})
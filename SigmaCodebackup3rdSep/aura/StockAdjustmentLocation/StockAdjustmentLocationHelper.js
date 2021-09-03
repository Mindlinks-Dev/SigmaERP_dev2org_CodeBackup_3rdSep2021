({
	helperMethod : function() {
		
	},
     getBinDetailsHelper : function(component, event, helper){
        
        var action = component.get("c.fetchILPLocation");         
        action.setParams({ 
            "locId" : component.get("v.locID"),
            "productID" : component.get("v.productID")
        });
        action.setCallback( this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){ 
                if(response.getReturnValue()){                                
                    component.set("v.SAILP",response.getReturnValue());
                    //alert(JSON.stringify(component.get('v.SAILP')));
                }else{
                    alert('"No Record Found"');
                }
            }          
        });
        $A.enqueueAction(action); 
    }
})
({
    //code added to fetch the records based on particular vendor id 
    toGetcustomerData: function(component, event,helper) {
        //alert('call helper');
        var action = component.get("c.fetchProduct");
        
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                //alert('success'+ JSON.stringify(response.getReturnValue()));
                var resultData = response.getReturnValue();
                
                component.set("v.productList",JSON.stringify(response.getReturnValue()));
                //alert('productList>>>'+JSON.stringify(component.get("v.productList")));
            }
            
        });
        
        $A.enqueueAction(action);
        
    },
    /*toGetLocationData:function(component, event,helper) {
        alert('inside location')
        var action = component.get("c.fetchLocation");
        
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                alert('success'+ JSON.stringify(response.getReturnValue()));
                var resultData = response.getReturnValue();
                
                component.set("v.productList",JSON.stringify(response.getReturnValue()));
                alert('productList>>>'+JSON.stringify(component.get("v.productList")));
            }
            
        });
        
        $A.enqueueAction(action);
        
    },*/
        
    
})
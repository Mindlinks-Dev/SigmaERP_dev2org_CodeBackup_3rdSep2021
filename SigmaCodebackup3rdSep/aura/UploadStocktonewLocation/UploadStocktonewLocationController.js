({
    fetchVendProds : function(component, event, helper) {
        var action = component.get("c.fetchVendProdlist");
       
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('state>>>>'+response.getReturnValue());
            if (state === "SUCCESS") {
                component.set("v.Vplist", response.getReturnValue());
               // alert('Vplist>>>'+component.set("v.Vplist"));
            }
        });
        $A.enqueueAction(action);
    },
      // function for save the Records 
    Save: function(component, event, helper) {
       
        if (helper.validateRequired(component, event)) {
            // call the apex class method for save the Contact List
            // with pass the contact List attribute to method param.  
            var action = component.get("c.saveVendproducts");
            alert('vplist>>>'+component.get("v.Vplist"));
            action.setParams({
                "vplistdata": component.get("v.Vplist")
            });
            // set call back 
            action.setCallback(this, function(response) {
                var state = response.getState();
                alert('state>>>'+state);
                if (state === "SUCCESS") {
                    // if response if success then reset/blank the 'contactList' Attribute 
                    // and call the common helper method for create a default Object Data to Contact List 
                    component.set("v.vplistdata", []);
                   // helper.createObjectData(component, event);
                    alert('record Saved succesfully');
                }
            });
            // enqueue the server side action  
            $A.enqueueAction(action);
        }
    },
 
})